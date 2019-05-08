# frozen_string_literal: true

# Callbacks provide an extensible mechanism for hooking into a Flow.
module Flow
  module Callbacks
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Callbacks
      define_callbacks :initialize, :trigger, :flux
    end
  end
end
