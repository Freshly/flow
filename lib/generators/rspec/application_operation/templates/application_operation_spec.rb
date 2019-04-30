# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationOperation, type: :operation do
  subject(:operation) { described_class.new(state) }

  let(:state) { double }

  it { is_expected.to inherit_from Flow::OperationBase }

  describe "#execute" do
    subject(:execute) { operation.execute }

    it "has some behavior"
  end

  describe "#rewind" do
    subject(:rewind) { operation.rewind }

    before { operation.execute }

    it "undoes some behavior"
  end
end
