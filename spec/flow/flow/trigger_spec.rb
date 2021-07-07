# frozen_string_literal: true

RSpec.describe Flow::Flow::Trigger, type: :concern do
  include_context "with example flow having state"

  it { is_expected.to delegate_method(:valid?).to(:state).with_prefix(true) }

  describe ".trigger!" do
    it_behaves_like "a class pass method", :trigger! do
      let(:test_class) { example_flow_class }
      let(:call_class) { example_flow_class }
    end
  end

  describe ".trigger" do
    it_behaves_like "a class pass method", :trigger do
      let(:test_class) { example_flow_class }
      let(:call_class) { example_flow_class }
    end
  end

  describe "#trigger!" do
    subject(:trigger!) { example_flow.trigger! }

    let(:state) { instance_double(example_state_class) }

    before do
      allow(example_flow).to receive(:state).and_return(state)
      allow(example_flow).to receive(:flux)
      allow(state).to receive(:valid?).and_return(state_valid?)
    end

    context "when the state is valid" do
      before { allow(example_flow).to receive(:surveil).and_call_original }

      let(:state_valid?) { true }

      it { is_expected.to eq example_flow }

      it "is surveiled" do
        trigger!
        expect(example_flow).to have_received(:flux)
        expect(example_flow).to have_received(:surveil).with(:trigger)
      end
    end

    context "when the state is NOT valid" do
      let(:state_valid?) { false }

      it "does not executes operations" do
        expect { trigger! }.to raise_error Flow::StateInvalidError
        expect(example_flow).not_to have_received(:flux)
      end
    end
  end

  describe "#trigger" do
    subject(:trigger) { example_flow.trigger }

    context "with valid state" do
      let(:state) { instance_double(example_state_class) }

      before { allow(example_flow).to receive(:trigger!).and_return(example_flow) }

      it { is_expected.to eq example_flow }
    end

    context "with invalid state" do
      before { allow(example_flow).to receive(:trigger!).and_raise(Flow::StateInvalidError) }

      it { is_expected.to eq example_flow }

      it { is_expected.to be_malfunction }

      it "sets malfunction" do
        expect { trigger }.to change { example_flow.malfunction }.to(instance_of(Flow::Malfunction::InvalidState))

        expect(example_flow.malfunction).to have_attributes(state: example_flow.state)
      end
    end
  end
end
