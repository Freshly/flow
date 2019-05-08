# frozen_string_literal: true

# A callback driven approach to wrap business logic within database transaction.
module Flow
  module TransactionWrapper
    extend ActiveSupport::Concern

    class_methods do
      def transaction_provider
        ActiveRecord::Base
      end

      private

      def wrap_in_transaction
        set_callback callback_name, :around, ->(_, block) { self.class.transaction_provider.transaction { block.call } }
      end
    end
  end
end
