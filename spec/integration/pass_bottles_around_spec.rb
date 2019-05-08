# frozen_string_literal: true

require_relative "../support/test_classes/pass_bottles_around"

RSpec.describe PassBottlesAround, type: :operation do
  subject { described_class.new(double) }

  it { is_expected.to wrap_in_transaction }
  it { is_expected.to define_failure :too_generous }
  it { is_expected.to handle_error ActiveRecord::RecordInvalid }
  it { is_expected.to handle_error described_class::NonTakedownError, with: :non_takedown_handler }
end
