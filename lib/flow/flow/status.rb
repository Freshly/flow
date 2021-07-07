# frozen_string_literal: true

# The Flow status is a summary of what has occurred during the runtime, used mainly for analysis and program flow.
module Flow
  module Flow
    module Status
      extend ActiveSupport::Concern

      def pending?
        executed_operations.none?
      end

      def triggered?
        executed_operations.any? || failed_operation?
      end

      def success?
        triggered? && (operation_instances - executed_operations).none?
      end

      def failed?
        triggered? && !success?
      end

      def malfunction?
        malfunction.present?
      end
    end
  end
end
