# frozen_string_literal: true

require_relative "../support/test_classes/bottles_on_the_wall_flow"

RSpec.describe BottlesOnTheWallFlow, type: :flow do
  subject { described_class.new(bottles_of: :test_fluid) }

  let(:expected_operations) { [ CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles ] }

  it { is_expected.to use_operations(*expected_operations) }
  it { is_expected.to wrap_in_transaction }
end
