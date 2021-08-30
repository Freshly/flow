# frozen_string_literal: true

RSpec.describe Flow::StateProxy, type: :state_proxy do
  include_context "with an example state"

  subject(:state_proxy) { described_class.new(state) }

  let(:state) { example_state }

  describe "#state" do
    subject { state_proxy.__send__(:_state) }

    it { is_expected.to eq example_state }
  end

  describe "#respond_to?" do
    subject { state_proxy.respond_to?(method_name) }

    let(:example_method_name) do
      Array.new(2) { Faker::Internet.domain_word }.join("_")
    end
    let(:method_name) { example_method_name.to_sym }

    before { allow(example_state).to receive(:respond_to?).with(method_name).and_return(state_respond_to?) }

    context "without state.respond_to?" do
      let(:state_respond_to?) { false }

      it { is_expected.to eq false }
    end

    context "when state.respond_to?" do
      let(:state_respond_to?) { true }

      it { is_expected.to eq true }
    end
  end

  describe "#method_missing" do
    subject(:call) { state_proxy.public_send(method_name, *arguments) }

    let(:arguments) { [] }
    let(:example_method_name) do
      Array.new(2) { Faker::Internet.domain_word }.join("_")
    end
    let(:method_name) { example_method_name.to_sym }
    let(:value_from_state) { double }

    before { allow(example_state).to receive(:respond_to?).with(method_name).and_return(state_respond_to?) }

    shared_examples_for "a NoMethodError is raised" do
      it "raises NoMethodError" do
        expect { call }.to raise_error do |error|
          expect(error).to be_an_instance_of NoMethodError
          expect(error.message).to include "undefined method `#{method_name}' for"
        end
      end
    end

    context "without state.respond_to?" do
      let(:state_respond_to?) { false }

      it_behaves_like "a NoMethodError is raised"
    end

    context "when state.respond_to?" do
      let(:state_respond_to?) { true }

      before { allow(example_state).to receive(method_name).with(no_args).and_return(value_from_state) }

      it { is_expected.to eq value_from_state }
    end
  end
end
