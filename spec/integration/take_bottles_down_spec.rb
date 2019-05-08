# frozen_string_literal: true

require_relative "../support/test_classes/take_bottles_down"

RSpec.describe TakeBottlesDown, type: :operation do
  subject { described_class.new(double) }

  it { is_expected.to wrap_in_transaction }
  it { is_expected.to define_failure :too_greedy }
  it { is_expected.to handle_error described_class::NonTakedownError, with: :a_block }
end
