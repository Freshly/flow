# frozen_string_literal: true

class CountOutCurrentBottles < Flow::OperationBase
  allow_direct_state_access

  def behavior
    state.stanza.push "#{state.bottles} on the wall#{", #{state.bottles}" if state.stanza.empty?}."
  end
end
