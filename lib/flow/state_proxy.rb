# frozen_string_literal: true

# A **StateProxy** adapts a **State** to an **Operation** through an Operation's `state_*` accessors.
module Flow
  class StateProxy
    def initialize(state, operation)
      @state = state
      @operation = operation
    end

    # @deprecated
    def method_missing(method_name, *arguments, &block)
      return super unless state.respond_to?(method_name)

      unless @operation.executed?
        ActiveSupport::Deprecation.warn(
          "Direct state access of `#{method_name}' on #{state.inspect} will be removed in a future version of flow. "\
          "Use a state accessor instead - for more information see github/freshly/flow/deprecation_notice"
        )
      end
      # Until this is deprecated, move line 22 under line 15.
      state.public_send(method_name, *arguments, &block)
    end

    # @deprecated
    def respond_to_missing?(method_name, include_private = false)
      state.respond_to?(method_name) || super
    end

    private

    attr_reader :state
  end
end
