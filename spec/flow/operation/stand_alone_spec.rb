# frozen_string_literal: true

RSpec.describe Flow::Operation::StandAlone, type: :module do

  shared_examples_for "operation is run in isolation" do
    include_context "with an example operation"

    subject(:call_standalone_operation) { example_operation_class.public_send(call_standalone_operation_method, arguments) }

    let(:arguments) { { attribute => value } }
    let(:attribute) { Faker::Lorem.word.to_sym }
    let(:value) {Faker::Lorem.word.to_sym  }

    before { example_operation_class.include(described_class) }

    describe "introspected state" do
      context "with defined state_reader" do
        before { example_operation_class.__send__(:state_reader, attribute) }

        it { is_expected.to have_on_state(attribute => value, outputs: {}) }
      end

      context "with defined state_writer" do
        context "when state_writer attribute is an input" do
          before { example_operation_class.__send__(:state_writer, attribute) }

          it "raises" do
            expect { call_standalone_operation }.to raise_error Flow::NotValidatedError
          end
        end

        context "when state_writer attribute is NOT an input" do
          let(:arguments) { {} }

          before { example_operation_class.__send__(:state_writer, attribute) }

          it { is_expected.to have_on_state(attribute => nil, outputs: having_attributes(attribute => nil)) }
        end
      end

      context "with defined state_accessor" do
        before { example_operation_class.__send__(:state_accessor, attribute) }

        it do
          pending("state output bug is fix")
          is_expected.to have_on_state(attribute => value, outputs: having_attributes(attribute => value))
        end
      end
    end

    describe "calling the operation" do
      let(:operation) { instance_double(example_operation_class) }
      let(:introspected_state) { instance_double(Flow::StateBase) }

      before do
        allow(example_operation_class).to receive(:introspected_state).with(arguments).and_return(introspected_state)
        allow(example_operation_class).to receive(:new).with(introspected_state).and_return(operation)
        allow(operation).to receive(expected_operation_execution_method)

        call_standalone_operation
      end

      it "executes the operation" do
        expect(operation).to have_received(expected_operation_execution_method)
      end
    end
  end

  describe "#trigger!" do
    it_behaves_like "operation is run in isolation" do
      let(:call_standalone_operation_method) { :trigger! }
      let(:expected_operation_execution_method) { :execute! }
    end
  end

  describe "#trigger" do
    it_behaves_like "operation is run in isolation" do
      let(:call_standalone_operation_method) { :trigger }
      let(:expected_operation_execution_method) { :execute }
    end
  end
end
