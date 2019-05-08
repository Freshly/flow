# frozen_string_literal: true

# Callbacks provide an extensible mechanism for hooking into a Operation.
module Flow
  module Operation
    module Callbacks
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks
        define_callbacks :failure, :execute, :behavior
      end

      class_methods do
        def on_failure(*filters, &block)
          set_callback(:failure, :before, *filters, &block)
        end
      end
    end
  end
end
