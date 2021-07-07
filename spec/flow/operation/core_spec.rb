# frozen_string_literal: true

RSpec.describe Flow::Operation::Core, type: :concern do
  include_context "with an example operation"

  it { is_expected.to delegate_method(:state_proxy_class).to(:class) }

  describe "#initialize" do
    subject(:operation) { example_operation }

    it "has state proxy" do
      expect(operation.state.class < Flow::StateProxy).to eq true
      expect(operation.state.__send__(:_state)).to eq example_state
    end
  end

  describe "#state_proxy_class" do
    subject(:state_proxy_class) { example_operation_class.state_proxy_class }

    it { is_expected.to inherit_from Flow::StateProxy }

    describe "inheritance" do
      let(:child_operation_class) { Class.new(example_operation_class) }

      it "is not inherited" do
        expect { state_proxy_class }.to change { example_operation_class.instance_variable_get(:@state_proxy_class) }
        expect(child_operation_class.instance_variable_get(:@state_proxy_class)).to be_nil
        expect(child_operation_class.state_proxy_class).not_to eq state_proxy_class
        expect(child_operation_class.state_proxy_class < Flow::StateProxy).to eq true
      end
    end

    describe "with reader" do
      subject { state_proxy_class.new(example_state) }

      before { example_operation_class.__send__(:state_reader, :test_reader) }

      it { is_expected.to delegate_method(:test_reader).to(:_state) }
    end

    describe "with writer" do
      subject { state_proxy_class.new(example_state) }

      before { example_operation_class.__send__(:state_writer, :test_writer) }

      it { is_expected.to delegate_method(:test_writer=).to(:_state).with_arguments(:value) }
    end

    describe "with accessor" do
      subject { state_proxy_class.new(example_state) }

      before { example_operation_class.__send__(:state_accessor, :attribute) }

      it { is_expected.to delegate_method(:attribute).to(:_state).with_arguments(:value) }
      it { is_expected.to delegate_method(:attribute=).to(:_state).with_arguments(:value) }
    end
  end
end
