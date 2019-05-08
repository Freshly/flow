# frozen_string_literal: true

# When an exception is raised during during execution, but a handler can rescue, it causes a failure instead.
module Flow
  module Operation
    module ErrorHandler
      extend ActiveSupport::Concern

      class_methods do
        private

        def handle_error(error_class, problem: error_class.name.demodulize.underscore, with: nil, &block)
          failure problem

          rescue_from(error_class) { |exception| fail!(problem.to_sym, exception: exception) }

          if with.present?
            rescue_from(error_class, with: with)
          elsif block_given?
            rescue_from(error_class, &block)
          end
        end

        def handle_errors(*errors)
          errors.flatten.each(&method(:handle_error))
        end
      end
    end
  end
end
