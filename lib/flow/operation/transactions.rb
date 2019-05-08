# frozen_string_literal: true

# Operations which modify several persisted objects together should use a transaction.
module Flow
  module Operation
    module Transactions
      extend ActiveSupport::Concern

      class_methods do
        def callback_name
          :behavior
        end
      end
    end
  end
end
