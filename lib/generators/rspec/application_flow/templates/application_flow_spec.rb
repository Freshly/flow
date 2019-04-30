# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationFlow, type: :flow do
  it { is_expected.to inherit_from Flow::FlowBase }
end
