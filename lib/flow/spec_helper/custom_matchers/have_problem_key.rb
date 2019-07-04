# frozen_string_literal: true

module Flow
  module CustomMatchers
    def have_problem_key(expectation)
      HaveProblemKey.new(expectation)
    end

    class HaveProblemKey
      include RSpec::Matchers

      def initialize(expectation)
        @expectation = expectation
      end

      def matches?(object)
        expect(problem(object)).to eq @expectation
      end

      def description
        "have the expected problem key"
      end

      private

      def problem(object)
        if object.is_a? ApplicationFlow
          object.failed_operation.operation_failure.problem
        elsif object.is_a? ApplicationOperation
          object.operation_failure.problem
        else
          object.problem
        end
      end
    end
  end
end
