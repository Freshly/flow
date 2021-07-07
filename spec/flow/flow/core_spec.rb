# frozen_string_literal: true

RSpec.describe Flow::Flow::Core, type: :concern do
  include_context "with example flow having state"

  it { is_expected.to include_module Conjunction::Junction }

  it { is_expected.to delegate_method(:state_class).to(:class) }
  it { is_expected.to delegate_method(:outputs).to(:state) }

  describe ".state_class" do
    subject { example_flow_class.state_class }

    it { is_expected.to eq example_state_class }
  end

  describe "#initialize" do
    include_context "with example class having callback", :initialize

    subject(:instance) { example_flow_class.new(**arguments) }

    let(:arguments) { Hash[*Faker::Lorem.unique.words(number: 4)].symbolize_keys }

    context "when the state class is NOT defined" do
      let(:example_state_name) { "Other#{example_name}State" }

      it "raises" do
        expect { instance }.to raise_error NameError
      end
    end

    context "when the state class is defined" do
      before do
        arguments.each_key { |argument| example_state_class.__send__(:argument, argument) }
      end

      it "assigns a state with the input data" do
        expect(instance.state).to be_a example_state_class
        arguments.each { |argument, value| expect(instance.state.public_send(argument)).to eq value }
      end

      context "when the argument is a state class instance" do
        subject(:instance) { example_flow_class.new(example_state_class) }

        it "assigns the argument as the state" do
          expect(instance.state).to eq(example_state_class)
        end
      end
    end
  end
end
