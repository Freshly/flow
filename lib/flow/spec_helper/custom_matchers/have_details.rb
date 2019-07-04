# frozen_string_literal: true

module Flow
  module CustomMatchers
    def have_details(expectation)
      HaveDetails.new(expectation)
    end

    class HaveDetails
      include RSpec::Matchers

      def initialize(expectation)
        if expectation.is_a? Hash
          @expectation = OpenStruct.new(expectation)
        else
          @expectation = expectation
        end
      end

      def matches?(object)
        expect(details(object)).to eq @expectation
      end

      def description
        "have the expected details"
      end

      private

      def details(object)
        if object.is_a? ApplicationFlow
          object.failed_operation.operation_failure.details
        elsif object.is_a? ApplicationOperation
          object.operation_failure.details
        else
          object.details
        end
      end
    end
  end
end
