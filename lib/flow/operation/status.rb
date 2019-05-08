# frozen_string_literal: true

# The Operation status is used by the Flow calling it to determine what to do next; continue on or stop and rollback.
module Flow
  module Operation
    module Status
      extend ActiveSupport::Concern

      included do
        set_callback(:execute, :before) { self.was_executed = true }

        private

        attr_accessor :was_executed
      end

      def executed?
        was_executed.present?
      end

      def failed?
        operation_failure.present?
      end

      def success?
        executed? && !failed?
      end
    end
  end
end
