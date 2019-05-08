# frozen_string_literal: true

require_relative "operation/errors/already_executed"
require_relative "operation/errors/already_rewound"

require_relative "operation/accessors"
require_relative "operation/callbacks"
require_relative "operation/core"
require_relative "operation/error_handler"
require_relative "operation/execute"
require_relative "operation/failures"
require_relative "operation/status"
require_relative "operation/transactions"

# An **Operation** is a service object which is executed with a **State**.
module Flow
  class OperationBase
    include ShortCircuIt
    include Technologic
    include Flow::TransactionWrapper
    include Flow::Operation::Accessors
    include Flow::Operation::Callbacks
    include Flow::Operation::Core
    include Flow::Operation::ErrorHandler
    include Flow::Operation::Execute
    include Flow::Operation::Failures
    include Flow::Operation::Status
    include Flow::Operation::Transactions
  end
end
