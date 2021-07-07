# frozen_string_literal: true

module Flow
  module Malfunction
    # An abstract problem originating from within Flow
    class Base < ::Malfunction::MalfunctionBase
      prefixed_with "Flow::Malfunction::"
      suffixed_with nil
    end
  end
end
