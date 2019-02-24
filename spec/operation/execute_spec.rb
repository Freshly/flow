# frozen_string_literal: true

RSpec.describe Operation::Execute, type: :module do
  subject(:example_class) { Class.new.include described_class }

  it { is_expected.to include_module ActiveSupport::Rescuable }

  include_context "with an example operation", [ ActiveSupport::Rescuable, Operation::Transactions, Operation::Execute ]

  describe ".execute!" do
    it_behaves_like "a class pass method", :execute! do
      let(:test_class) { example_operation_class }
    end
  end

  describe ".execute" do
    it_behaves_like "a class pass method", :execute do
      let(:test_class) { example_operation_class }
    end
  end

  describe "#execute!" do
    subject(:execute!) { example_operation.execute! }

    before do
      allow(example_operation).to receive(:surveil).and_call_original
      allow(example_operation).to receive(:behavior)
    end

    it_behaves_like "a class with callback" do
      subject(:callback_runner) { execute! }

      before do
        example_operation_class.attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
        example_operation_class.set_callback(:execute, :before) { |obj| obj.before_hook_run = true }
        example_operation_class.set_callback(:execute, :after) { |obj| obj.after_hook_run = true }
        example_operation_class.set_callback :execute, :around do |obj, block|
          obj.around_hook_run = true
          block.call
        end
      end

      let(:example) { example_operation }
    end

    it_behaves_like "a class with callback" do
      subject(:callback_runner) { execute! }

      before do
        example_operation_class.attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
        example_operation_class.set_callback(:behavior, :before) { |obj| obj.before_hook_run = true }
        example_operation_class.set_callback(:behavior, :after) { |obj| obj.after_hook_run = true }
        example_operation_class.set_callback :behavior, :around do |obj, block|
          obj.around_hook_run = true
          block.call
        end
      end

      let(:example) { example_operation }
    end

    it "calls #behavior" do
      execute!
      expect(example_operation).to have_received(:behavior).with(no_args)
    end

    it "is surveiled" do
      execute!
      expect(example_operation).to have_received(:surveil).with(:execute)
    end

    context "when an error occurs" do
      let(:example_error) { Class.new(StandardError) }

      before { allow(example_operation).to receive(:behavior).and_raise(example_error) }

      shared_examples_for "an error is raised" do
        let(:expected_error) { example_error }

        it "raises" do
          expect { execute! }.to raise_error expected_error
        end
      end

      context "with no rescue_from" do
        it_behaves_like "an error is raised"
      end

      context "with a rescue_from" do
        context "when it reraises" do
          before do
            example_operation_class.rescue_from(StandardError) { |exception| raise exception }
          end

          it_behaves_like "an error is raised"
        end

        context "when it raises a new error" do
          before do
            example_operation_class.rescue_from(StandardError) { raise StandardError }
          end

          it_behaves_like "an error is raised" do
            let(:expected_error) { StandardError }
          end
        end

        context "when it rescues" do
          before do
            example_operation_class.rescue_from(StandardError) { true }
          end

          it "doesn't raise" do
            expect { execute! }.not_to raise_error
          end
        end
      end
    end
  end

  describe "#execute" do
    subject(:execute) { example_operation.execute }

    context "when nothing goes wrong" do
      let(:execute_response) { double }

      before { allow(example_operation).to receive(:execute!).and_return(execute_response) }

      it { is_expected.to eq execute_response }
    end

    context "when a failure occurs" do
      before { allow(example_operation).to receive(:execute!).and_raise(Operation::Failures::OperationFailure) }

      it { is_expected.to eq false }

      it "tracks the failure" do
        expect { execute }.
          to change { example_operation.__send__(:operation_failure) }.
          from(nil).
          to(instance_of(Operation::Failures::OperationFailure))
      end
    end

    context "when an unexpected error occurs" do
      before { allow(example_operation).to receive(:execute!).and_raise(StandardError) }

      it "raises" do
        expect { execute }.to raise_error(StandardError)
      end
    end
  end

  describe "#behavior" do
    subject(:behavior) { example_operation.behavior }

    it { is_expected.to eq nil }
  end
end
