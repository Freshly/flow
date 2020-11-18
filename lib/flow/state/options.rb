# frozen_string_literal: true

# Overides .option in Spicerack::Objects::Options so that a defined option can be opted to behave like an output
module Flow
  module State
    module Options
      extend ActiveSupport::Concern

      class_methods do
        private

        def option(option, output: false, **options)
          _outputs << option if output
          super(option, **options)
        end
      end
    end
  end
end
