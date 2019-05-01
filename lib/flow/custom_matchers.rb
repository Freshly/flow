# frozen_string_literal: true

require_relative "custom_matchers/define_argument"
require_relative "custom_matchers/define_attribute"
require_relative "custom_matchers/define_failure"
require_relative "custom_matchers/define_option"
require_relative "custom_matchers/define_output"
require_relative "custom_matchers/handle_error"
require_relative "custom_matchers/use_operations"
require_relative "custom_matchers/wrap_in_transaction"
require_relative "custom_matchers/have_failure"
require_relative "custom_matchers/have_on_state"

module CustomMatchers
  def have_failure(problem)
    HaveFailure.new(problem)
  end

  def have_on_state(state_stuff)
    HaveOnState.new(state_stuff)
  end
end
