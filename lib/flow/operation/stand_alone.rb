# frozen_string_literal: true

# Allows operations to be called outside of a flow via .trigger and .trigger!.
module Flow
  module Operation
    module StandAlone
      extend ActiveSupport::Concern

      class_methods do
        def trigger(**kwargs)
          new(introspected_state(kwargs)).execute
        end

        def trigger!(**kwargs)
          new(introspected_state(kwargs)).execute!
        end

        private

        def introspected_state(kwargs)
          introspected_state_class.new(kwargs).tap(&:validate)
        end

        def introspected_state_class
          @introspected_state_class ||= Class.new(StateBase).tap do |state_class|
            _state_readers.each { |method_name| state_class.__send__(:option, method_name) }
            _state_writers.each { |method_name| state_class.__send__(:output, method_name) }
          end
        end
      end
    end
  end
end
