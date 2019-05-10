# frozen_string_literal: true

# RSpec matcher for making assertions on the state of a Flow or Operation after it has been run.
#
# class ExampleOperation
#   def behavior
#     state.foo = "some data"
#     state.bar = "some other data"
#   end
# end
#
# class ExampleFlow
#   operations [ ExampleOperation ]
# end
#
# RSpec.describe ExampleOperation, type: :operation do
#   subject { operation.execute }
#
#   it { is_expected.to have_on_state foo: "some data" }
#   it { is_expected.to have_on_state foo: instance_of(String) }
#   it { is_expected.to have_on_state foo: "some data", bar: "some other data" }
# end
#
# RSpec.describe ExampleFlow, type: :operation do
#   subject { flow.trigger }
#
#   it { is_expected.to have_on_state foo: "some data" }
#   it { is_expected.to have_on_state foo: instance_of(String) }
#   it { is_expected.to have_on_state foo: "some data", bar: "some other data" }
# end

module CustomMatchers
  def have_on_state(expectations)
    HaveOnState.new(expectations)
  end

  class HaveOnState
    include RSpec::Matchers

    def initialize(state_expectations)
      @state_expectations = state_expectations
    end

    def matches?(object)
      @state_expectations.all? do |key, value|
        expect(object.state.public_send(key)).to match value
      end
    end

    def description
      "have the expected data on state"
    end
  end
end
