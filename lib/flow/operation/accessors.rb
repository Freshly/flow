# frozen_string_literal: true

require "set"

module Flow
  module Operation
    module Accessors
      extend ActiveSupport::Concern

      included do
        class_attribute :_state_readers, instance_writer: false, default: Set.new
        class_attribute :_state_writers, instance_writer: false, default: Set.new
        class_attribute :_state_accessors, instance_writer: false, default: Set.new
      end

      module ClassMethods
        protected

        def state_reader(*names, prefix: false)
          names.each do |name|
            delegate name, prefix: prefix, to: :state

            _add_state_reader_tracker(name.to_sym)
          end
        end

        def state_writer(*names, prefix: false)
          names.each do |name|
            delegate "#{name}=", prefix: prefix, to: :state

            _add_state_writer_tracker(name.to_sym)
          end
        end

        def state_accessor(*names, prefix: false)
          names.each do |name|
            state_reader name, prefix: prefix
            state_writer name, prefix: prefix
          end
        end

        private

        def _add_state_reader_tracker(name)
          _state_accessors << name if _state_writers.include?(name)
          _state_readers << name
        end

        def _add_state_writer_tracker(name)
          _state_accessors << name if _state_readers.include?(name)
          _state_writers << name
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
