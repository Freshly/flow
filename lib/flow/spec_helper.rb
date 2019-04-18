# frozen_string_literal: true

require_relative "custom_matchers"
require_relative "shoulda_matcher_helper"

RSpec.configure do |config|
  config.include CustomMatchers
end
