# frozen_string_literal: true

RSpec.describe Flow::Flow::Malfunction, type: :concern do
  include_context "with example flow having state"

  describe "#build_malfunction" do
    subject(:build_malfunction) { example_flow.__send__(:build_malfunction, malfunction_class, context) }

    let(:malfunction_class) { Flow::Malfunction::FailedOperation }
    let(:context) { instance_double(Flow::OperationBase) }

    it "sets malfunction" do
      expect { build_malfunction }.to change { example_flow.malfunction }.to(instance_of(malfunction_class))

      expect(example_flow.malfunction).to have_attributes(context: context)
    end
  end
end
