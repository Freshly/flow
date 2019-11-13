# frozen_string_literal: true

RSpec.describe Flow::Operation::Core, type: :module do
  include_context "with an example operation"

  it { is_expected.to delegate_method(:direct_state_access?).to(:class) }

  describe "#initialize" do
    subject { example_operation.state }

    it { is_expected.to eq state }
  end

  describe ".direct_state_access?" do
    subject { example_operation_class }

    let(:direct_state_access?) { false }

    context "without allow_direct_state_access" do
      it { is_expected.not_to be_direct_state_access }
    end

    context "with allow_direct_state_access" do
      before { example_operation_class.__send__(:allow_direct_state_access) }

      it { is_expected.to be_direct_state_access }
    end
  end

  describe ".allow_direct_state_access" do
    subject(:allow_direct_state_access) { example_operation_class.__send__(:allow_direct_state_access) }

    let(:direct_state_access?) { false }

    it "changes direct_state_access" do
      expect { allow_direct_state_access }.to change { example_operation_class.direct_state_access? }.to(true)
    end
  end

  describe ".inherited" do
    subject(:child_operation_class) { Class.new(example_operation_class) }

    before { example_operation_class.__send__(:allow_direct_state_access) }

    it { is_expected.to be_direct_state_access }
  end
end
