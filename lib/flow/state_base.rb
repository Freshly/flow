# frozen_string_literal: true

require_relative "state/arguments"
require_relative "state/options"

# A **State** is an aggregation of input and derived data.
module Flow
  class StateBase < Spicerack::OutputObject
    include Conjunction::Junction
    suffixed_with "State"

    include State::Arguments
    include State::Options
  end
end
