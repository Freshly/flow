# frozen_string_literal: true

class PassBottlesAround < Flow::OperationBase
  wrap_in_transaction

  class NonTakedownError < StandardError; end

  BORING_DRINKS = %w[juice water soda pop]

  failure :too_generous
  failure :not_dangerous_enough, unless: :drink_not_boring?
  handle_errors ActiveRecord::RecordInvalid
  handle_error NonTakedownError, with: :non_takedown_handler

  on_record_invalid_failure do
    state.stanza.push "Passing the bottles wasn't as sound, now there's #{state.number_to_take_down} on the ground!"
  end

  set_callback(:execute, :after) { state.stanza.push "You pass #{state.taking_down_one? ? "it" : "them"} around." }

  def behavior
    too_generous_failure! if state.number_to_take_down >= 4
    raise NonTakedownError if state.number_to_take_down == 0

    state.bottles.update!(number_passed_around: state.bottles.number_passed_around + state.number_to_take_down)
  end

  private

  def drink_not_boring?
    BORING_DRINKS.exclude? state.bottles_of
  end

  def non_takedown_handler
    state.stanza.push "You pass nothing around."
  end
end
