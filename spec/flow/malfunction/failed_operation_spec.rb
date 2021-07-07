# frozen_string_literal: true

RSpec.describe Flow::Malfunction::FailedOperation, type: :malfunction do
  include_context "with an example operation"

  subject(:malfunction) { described_class.new(example_operation) }

  it { is_expected.to inherit_from Flow::Malfunction::Base }

  it { is_expected.to have_prototype_name "FailedOperation" }

  it { is_expected.not_to use_attribute_errors }
  it { is_expected.to contextualize_as :operation }

  it { is_expected.to delegate_method(:operation_failure).to(:operation) }
  it { is_expected.to delegate_method(:problem).to(:operation_failure) }
  it { is_expected.to delegate_method(:details).to(:operation_failure) }

  describe "#initialize" do
    context "with explicit details" do
      subject(:malfunction) { described_class.new(example_operation, details: { foo: true }) }

      it "raises" do
        expect { malfunction }.to raise_error ArgumentError, "Details cannot be assigned to #{described_class.name}"
      end
    end
  end
end
