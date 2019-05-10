# frozen_string_literal: true

module Flow
  module Operation
    module Accessors
      extend ActiveSupport::Concern

      included do
        class_attribute :_state_readers, instance_writer: false, default: []
        class_attribute :_state_writers, instance_writer: false, default: []
        class_attribute :_state_accessors, instance_writer: false, default: []
      end

      class_methods do
        protected

        def state_reader(name)
          return unless _add_state_reader_tracker(name.to_sym)

          delegate name, to: :state
        end

        def state_writer(name)
          return unless _add_state_writer_tracker(name.to_sym)

          delegate("#{name}=", to: :state)
        end

        def state_accessor(name)
          state_reader name
          state_writer name
        end

        private

        def _add_state_reader_tracker(name)
          return false if _state_readers.include?(name)

          _add_state_accessor_tracker(name) if _state_writers.include?(name)
          _state_readers << name
        end

        def _add_state_writer_tracker(name)
          return false if _state_writers.include?(name)

          _add_state_accessor_tracker(name) if _state_readers.include?(name)
          _state_writers << name
        end

        def _add_state_accessor_tracker(name)
          return if _state_accessors.include?(name)

          _state_accessors << name
        end

        def inherited(base)
          base._state_readers = _state_readers.dup
          base._state_writers = _state_writers.dup
          base._state_accessors = _state_accessors.dup

          super
        end
      end
    end
  end
end
