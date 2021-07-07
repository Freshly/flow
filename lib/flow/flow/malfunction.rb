# frozen_string_literal: true

module Flow
  module Flow
    # If a Flow doesn't complete successfully for any reason it creates a **Malfunction** to contextualize the failure.
    module Malfunction
      extend ActiveSupport::Concern

      included do
        attr_reader :malfunction
      end

      private

      def build_malfunction(malfunction_class, context)
        @malfunction = malfunction_class.build(context)
      end
    end
  end
end
