# frozen_string_literal: true

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
  class OperationBase < RootObject
    include TransactionWrapper
    include Operation::Accessors
    include Operation::Callbacks
    include Operation::Core
    include Operation::ErrorHandler
    include Operation::Execute
    include Operation::Failures
    include Operation::Status
    include Operation::Transactions
  end
end
