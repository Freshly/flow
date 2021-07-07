# frozen_string_literal: true

module Flow
  class Error < StandardError; end

  class FlowError < Error; end
  class StateInvalidError < FlowError; end
  class FluxError < FlowError; end

  class OperationError < Error; end
  class AlreadyExecutedError < OperationError; end

  class StateError < Error; end
  class NotValidatedError < StateError; end
end
