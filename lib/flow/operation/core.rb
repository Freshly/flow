# frozen_string_literal: true

# Operations take a state as input.
module Flow
  module Operation
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :state
        delegate :direct_state_access?, to: :class
      end

      class_methods do
        def inherited(base)
          base.allow_direct_state_access if direct_state_access?
        end

        def direct_state_access?
          @allow_direct_state_access.present?
        end

        protected

        def allow_direct_state_access
          @allow_direct_state_access = true
        end
      end

      def initialize(state)
        unless direct_state_access?
          ActiveSupport::Deprecation.warn "Implicit state access will be removed; use `.allow_direct_state_access'"
        end

        @state = state
      end
    end
  end
end
