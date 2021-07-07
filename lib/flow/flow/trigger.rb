# frozen_string_literal: true

# Triggering a Flow executes all its operations in sequential order (see `Flow::Flux`) *iff* it has a valid state.
module Flow
  module Flow
    module Trigger
      extend ActiveSupport::Concern

      class_methods do
        def trigger!(*arguments, **options)
          new(*arguments, **options).trigger!
        end

        def trigger(*arguments, **options)
          new(*arguments, **options).trigger
        end
      end

      included do
        delegate :valid?, :validated?, to: :state, prefix: true

        set_callback :trigger, :around, ->(_, block) { surveil(:trigger) { block.call } }
      end

      def trigger!
        raise StateInvalidError unless state_valid?

        run_callbacks(:trigger) { flux }

        self
      end

      def trigger
        trigger!
      rescue StateInvalidError
        build_malfunction ::Flow::Malfunction::InvalidState, state
        self
      end
    end
  end
end
