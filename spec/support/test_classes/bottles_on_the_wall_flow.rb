# frozen_string_literal: true

class BottlesOnTheWallFlow < Flow::FlowBase
  wrap_in_transaction

  operations CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles
end
