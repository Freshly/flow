# frozen_string_literal: true

class TakeBottlesDown < Flow::OperationBase
  wrap_in_transaction except: :undo

  class NonTakedownError < StandardError; end

  failure :too_greedy
  failure :too_dangerous, if: -> { state.bottles_of == "tequila" }
  handle_error NonTakedownError do
    state.stanza.push "You took nothing down."
  end

  on_failure do
    state.stanza.push "Something went wrong! It's the end of the song, and there's #{state.bottles} on the wall."
  end

  set_callback(:execute, :before) { bottle_count_term }
  set_callback(:execute, :after) { state.stanza.push "You take #{bottle_count_term} down." }

  def behavior
    too_greedy_failure! if state.number_to_take_down >= 5
    raise NonTakedownError if state.number_to_take_down == 0

    state.bottles.update!(number_on_the_wall: state.bottles.number_on_the_wall - state.number_to_take_down)
  end

  def undo
    state.bottles.reload.update!(number_on_the_wall: state.bottles.number_on_the_wall + state.number_to_take_down)
  end

  private

  def bottle_count_term
    return "it" if state.bottles.number_on_the_wall == 1
    return "one" if state.taking_down_one?

    state.number_to_take_down
  end
  memoize :bottle_count_term
end
