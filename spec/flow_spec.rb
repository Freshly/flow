# frozen_string_literal: true

RSpec.describe Flow do
  it "has a version number" do
    expect(Flow::VERSION).not_to be nil
  end

  describe described_class::Error do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::FlowError do
    it { is_expected.to inherit_from Flow::Error }
  end

  describe described_class::StateInvalidError do
    it { is_expected.to inherit_from Flow::FlowError }
  end

  describe described_class::FluxError do
    it { is_expected.to inherit_from Flow::FlowError }
  end

  describe described_class::OperationError do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::AlreadyExecutedError do
    it { is_expected.to inherit_from Flow::OperationError }
  end

  describe described_class::StateError do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::NotValidatedError do
    it { is_expected.to inherit_from Flow::StateError }
  end
end
