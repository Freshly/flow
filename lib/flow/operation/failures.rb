# frozen_string_literal: true

# When `#execute` is unsuccessful, expected problems are **failures** and unexpected problems are **Exceptions**.
module Flow
  module Operation
    module Failures
      extend ActiveSupport::Concern

      included do
        class_attribute :_failures, instance_writer: false, default: []

        delegate :_failures, to: :class
      end

      class_methods do
        def inherited(base)
          base._failures = _failures.dup
          super
        end

        private

        def failure(problem, **options)
          problem = problem.to_s.to_sym
          _failures << problem
          define_callbacks problem
          define_on_failure_for_problem(problem)
          define_fail_method_for_problem(problem)
          define_proactive_failure_for_problem(problem, **options)
        end

        def define_on_failure_for_problem(problem)
          on_failure_name = "on_#{problem}_failure".to_sym
          return if respond_to?(on_failure_name)

          define_singleton_method(on_failure_name) { |*filters, &block| set_callback(problem, :before, *filters, &block) }
        end

        def define_fail_method_for_problem(problem)
          problem_failure_name = "#{problem}_failure!".to_sym
          return if method_defined?(problem_failure_name)

          define_method(problem_failure_name) { |**details| fail!(problem, **details) }
        end

        def define_proactive_failure_for_problem(problem, **options)
          conditional_options = options.slice(:if, :unless)
          set_callback(:execute, :before, -> { fail!(problem) }, **conditional_options) if conditional_options.present?
        end
      end

      def fail!(problem, **details)
        run_callbacks(problem) do
          run_callbacks(:failure) do
            error! OperationFailure.new(problem, **details), **details
          end
        end
      end

      class OperationFailure < StandardError
        attr_reader :problem, :details

        def initialize(problem = nil, **details)
          super(problem)
          @problem = problem
          @details = OpenStruct.new(details)
        end
      end
    end
  end
end
