# frozen_string_literal: true

# Checks for failures and failure content on Operations AND Flows!

# Usage:
#
#   Flows:
#     subject { flow }
#
#     before { flow.trigger }
#
#     it { is_expected.to have_failure(:some_failure).with_details(some: details).on_operation(SomeOperation) }
#
#
#   Operations:
#     subject { operation }
#
#     before { operation.execute }
#
#     it { is_expected.to have_failure(:some_failure).with_details(some: details) }

# More details:
#   - `on_operation` WILL raise NotImplementedError if you use it on an operation.
#   - `with_details` AND `on_operation` are OPTIONAL

module CustomMatchers
  class HaveFailure
    def initialize(expected_problem)
      @expected_problem = expected_problem
    end

    def matches?(object)
      @object = object
      @operation_failure = operation_failure
      problem_matches? && details_match? && operation_matches?
    end

    def with_details(details)
      @details = details
      self
    end

    def on_operation(operation_class)
      @operation_class = operation_class
      self
    end

    def failure_message
      problem_matches? ? details_description : problem_description
    end

    def description
      "have the expected data on the failure"
    end

    private

    def operation_failure
      flow? ? @object.failed_operation&.operation_failure : @object.operation_failure
    end

    def flow?
      @object.class <= Flow::FlowBase
    end

    def problem_matches?
      @expected_problem == @operation_failure&.problem
    end

    def details_match?
      return true unless @details

      [ wrong_details, missing_details, extra_details ].all?(&:none?)
    end

    def operation_matches?
      return true unless @operation_class

      raise NotImplementedError unless flow?

      @operation_class == @object.failed_operation.class
    end

    def problem_description
      [ expected_problem_description, wrong_problem_description ].compact.join(". ")
    end

    def expected_problem_description
      "Expected to have failure with problem :#{@expected_problem}"
    end

    def wrong_problem_description
      "Did find failure :#{@operation_failure&.problem}" if @operation_failure&.problem
    end

    def details_description
      [ missing_details_description, extra_details_description, wrong_details_description ].compact.join("\n")
    end

    def missing_details_description
      "Expected failure to include details: :#{missing_details.join(", :")}" if missing_details.any?
    end

    def extra_details_description
      "Failure also included details: :#{extra_details.join(", :")}" if extra_details.any?
    end

    def wrong_details_description
      "Inaccurate data on details: \n" + wrong_details.map { |key| single_wrong_detail_description(key) }.join(",\n\n") if wrong_details.any?
    end

    def single_wrong_detail_description(key)
      "expected :#{key} to return #{expected_details[key]}, got #{actual_details[key]}".indent(2)
    end

    def actual_details
      @actual_details ||= @operation_failure.details.to_h
    end

    def expected_details
      @expected_details ||= @details.to_h
    end

    def missing_details
      @missing_details ||= expected_details.keys - actual_details.keys
    end

    def extra_details
      @extra_details ||= actual_details.keys - expected_details.keys
    end

    def matching_details
      @matching_details ||= expected_details.keys & actual_details.keys
    end

    def wrong_details
      @wrong_details ||= matching_details.reject do |key|
        actual_details[key] == expected_details[key]
      end
    end
  end
end
