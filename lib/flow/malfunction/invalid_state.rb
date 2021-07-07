# frozen_string_literal: true

module Flow
  module Malfunction
    # A problem arising when a Flow fails without processing any operations due to its initial state being invalid
    class InvalidState < Base
      uses_attribute_errors
      contextualize :state
      delegate :errors, to: :state, prefix: true

      on_build do
        state_errors.details.each do |attribute_name, error_details|
          attribute_messages = state_errors.messages[attribute_name]

          error_details.each_with_index do |error_detail, index|
            add_attribute_error(attribute_name, error_detail[:error], attribute_messages[index])
          end
        end
      end
    end
  end
end
