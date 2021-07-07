# frozen_string_literal: true

# When `#trigger` is called on a Flow, `#execute` is called on Operations sequentially in their given order.
module Flow
  module Flow
    module Flux
      extend ActiveSupport::Concern

      included do
        set_callback(:initialize, :after) { @executed_operations = [] }

        attr_reader :failed_operation

        delegate :operation_failure, to: :failed_operation, allow_nil: true

        private

        attr_reader :executed_operations

        def _flux
          executable_operations.each do |operation|
            operation.execute
            (@failed_operation = operation) and raise FluxError if operation.failed?
            
            executed_operations << operation
          end
        end

        def executable_operations
          operation_instances - executed_operations
        end

        def operation_instances
          _operations.map { |operation_class| operation_class.new(state) }
        end
        memoize :operation_instances
      end

      def failed_operation?
        failed_operation.present?
      end

      def flux
        flux!
      rescue StandardError => exception
        info :error_executing_operation, state: state, exception: exception

        raise exception unless exception.is_a? FluxError
        
        build_malfunction ::Flow::Malfunction::FailedOperation, @failed_operation
      end

      def flux!
        run_callbacks(:flux) { _flux }
      end
    end
  end
end
