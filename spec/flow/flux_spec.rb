# frozen_string_literal: true

RSpec.describe Flow::Flux, type: :module do
  include_context "with example flow having state", [ Flow::Operations, described_class ]

  describe "#executed_operations" do
    subject { example_flow.__send__(:executed_operations) }

    it { is_expected.to eq [] }
  end

  describe "#failed_operation" do
    subject { example_flow.failed_operation }

    it { is_expected.to eq nil }
  end

  describe "#failed_operation?" do
    subject { example_flow.failed_operation? }

    context "without a #failed_operation" do
      it { is_expected.to eq false }
    end

    context "with a #failed_operation" do
      let(:failed_operation) { instance_double(Flow::OperationBase) }

      before { allow(example_flow).to receive(:failed_operation).and_return(failed_operation) }

      it { is_expected.to eq true }
    end
  end

  describe "#flux" do
    subject(:flux) { example_flow.flux }

    let(:expected_state) { instance_of(example_state_class) }

    before do
      allow(example_flow).to receive(:error).and_call_original
    end

    context "when successful" do
      before { allow(example_flow).to receive(:flux!) }

      it "calls flux!" do
        flux
        expect(example_flow).to have_received(:flux!)
      end
    end

    context "with error" do
      let(:expected_exception) { instance_of(example_error) }

      before { allow(example_flow).to receive(:flux!).and_raise example_error }

      context "when Flow::Flux::Failure" do
        let(:example_error) { Flow::Flux::Failure }

        it "calls logs the exception without raising" do
          flux
          expect(example_flow).
            to have_received(:error).
            with(:error_executing_operation, state: expected_state, exception: expected_exception)
        end
      end

      context "when a descendant StandardError" do
        let(:example_error) { Class.new(StandardError) }

        it "calls logs the exception and raises" do
          expect { flux }.to raise_error example_error
          expect(example_flow).
            to have_received(:error).
            with(:error_executing_operation, state: expected_state, exception: expected_exception)
        end
      end
    end

    context "when a failure occurs" do
      let(:expected_exception) { instance_of(Flow::Flux::Failure) }

      before { allow(example_flow).to receive(:flux!).and_raise Flow::Flux::Failure }

      it "logs the exception" do
        flux
        expect(example_flow).
          to have_received(:error).
          with(:error_executing_operation, state: expected_state, exception: expected_exception)
      end
    end
  end

  describe "#flux!" do
    include_context "with operations for a flow"

    subject(:flux!) { example_flow.flux! }

    it_behaves_like "a class with callback" do
      include_context "with flow callbacks", :flux

      subject(:callback_runner) { flux! }

      let(:example) { example_flow }
    end

    let(:operation_failure) { instance_double(Flow::Operation::Failures::OperationFailure) }
    let(:operations) { example_flow.__send__(:operation_instances) }

    before do
      example_flow_class._operations = operation_classes
      operation_classes.each { |operation_class| allow(operation_class).to receive(:new).and_call_original }
      operations.each { |operation| allow(operation).to receive(:execute).and_call_original }
    end

    context "when nothing goes wrong" do
      it "executes all operations" do
        expect { flux! }.to change { example_flow.__send__(:executed_operations) }.from([]).to(instance_of_operations)
        expect(operation_classes).to all(have_received(:new).with(state).ordered)
        expect(operations).to all(have_received(:execute).ordered)
      end
    end

    context "with already executed operations" do
      before do
        example_flow.__send__(:executed_operations) << operations.first
      end

      it "executes all unexecuted operations" do
        expect { flux! }.
          to change { example_flow.__send__(:executed_operations) }.
          from([ operations.first ]).
          to(operations)
        expect(operations.first).not_to have_received(:execute)
        expect(operations.last(2)).to all(have_received(:execute).ordered)
      end
    end

    context "when an operation fails" do
      before do
        allow(operations.second).to receive(:operation_failure).and_return(operation_failure)
      end

      it "raises, sets failed operation, and halts" do
        expect { flux! }.
          to raise_error(Flow::Flux::Failure).
          and change { example_flow.__send__(:failed_operation) }.from(nil).to(operations.second).
          and change { example_flow.__send__(:executed_operations) }.from([]).to([ instance_of_operations.first ])
        expect(operations.last).not_to have_received(:execute)
      end
    end

    context "when an operation raises" do
      let(:example_error) { Class.new(StandardError) }

      before do
        operations.each_with_index do |operation, index|
          if index == 1
            allow(operation).to receive(:execute).and_raise example_error
          else
            allow(operation).to receive(:execute).and_call_original
          end
        end
      end

      it "raises" do
        expect { flux! }.
          to raise_error(example_error).
          and change { example_flow.__send__(:executed_operations) }.from([]).to([ instance_of_operations.first ])
        expect(operations.last).not_to have_received(:execute)
        expect(example_flow).not_to be_failed_operation
      end
    end
  end
end
