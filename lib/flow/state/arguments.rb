# frozen_string_literal: true

# Overides .option in Spicerack::Objects::Arguments so that a defined argument can be opted to behave like an output
module Flow
  module State
    module Arguments
      extend ActiveSupport::Concern

      class_methods do
        private

        def argument(argument, output: false, **options)
          _outputs << argument if output
          super(argument, **options)
        end
      end
    end
  end
end
