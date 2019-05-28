# frozen_string_literal: true

module Flow
  module Operation
    module Accessors
      extend ActiveSupport::Concern

      included do
        class_attribute :_state_readers, instance_writer: false, default: []
      end

      class_methods do
        protected

        def state_reader(name)
          return unless _add_state_reader_tracker(name.to_sym)

          delegate name, to: :state
        end

        private

        def _add_state_reader_tracker(name)
          return false if _state_readers.include?(name)

          _state_readers << name
        end

        def inherited(base)
          base._state_readers = _state_readers.dup

          super
        end
      end
    end
  end
end
