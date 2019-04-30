# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationState, type: :state do
  it { is_expected.to inherit_from Flow::StateBase }
end
