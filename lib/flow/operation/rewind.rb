# frozen_string_literal: true

# When something goes wrong in Flow, `#rewind` is called on all executed Operations to `#undo` their behavior.
module Flow
  module Operation
    module Rewind
      extend ActiveSupport::Concern

      included do
        set_callback :rewind, :around, ->(_, block) { surveil(:rewind) { block.call } }
        set_callback :rewind, :before, -> { raise Operation::Errors::AlreadyRewound }, if: :rewound?
      end

      def rewind
        run_callbacks(:rewind) do
          run_callbacks(:undo) { undo }
        end

        self
      end

      def undo
        # abstract method which should be defined by descendants to undo the functionality of the `#behavior` method
      end
    end
  end
end