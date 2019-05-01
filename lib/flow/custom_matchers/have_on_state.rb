# frozen_string_literal: true

module CustomMatchers
  class HaveOnState
    def initialize(state_stuff)
      @state_expectation = state_expectation
    end

    def matches?(object)
      @state = object.state
      hash_mode? ? all_match? : single_key_present? && attributes_match?
    end

    def with_attributes(attributes)
      @expected_attributes = attributes
      self
    end

    def failure_message
      "aaAa"
    end

    def description
      "have the expected data on state"
    end

    private

    def hash_mode?
      @hash_mode ||= @state_stuff.is_a?(Hash)
    end

    def all_match?
      @state_expectation.all? do |key, value|
        @state.try(key).match value
      end
    end

    def single_key_present?
      @state.respond_to?(@state_expectation)
    end

    def resource
      @resource ||= @state.public_send(@state_expectation)
    end

    def attributes_match?
      return true unless @expected_attributes

      raise NotImplementedError if hash_mode?

      @expected_attributes.all? do |key, value|
        resource.public_send(key).match value
      end
    end
  end
end