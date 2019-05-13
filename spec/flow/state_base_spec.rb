# frozen_string_literal: true

RSpec.describe Flow::StateBase, type: :state do
  subject { described_class }

  it { is_expected.to inherit_from Instructor::Base }

  it { is_expected.to include_module Flow::State::Status }
  it { is_expected.to include_module Flow::State::Output }
end
