# frozen_string_literal: true

# RSpec matcher that tests usage of `ApplicationState.option`
#
#     class ExampleState
#       option :foo
#       option :bar, default: :baz
#       option(:gaz) { :haz }
#     end
#
#     RSpec.describe ExampleState, type: :state do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_option :foo }
#       it { is_expected.to define_option :bar, :baz }
#       it { is_expected.to define_option :gaz, :haz }
#     end

RSpec::Matchers.define :define_option do |option, default_value = nil|
  match do |state|
    expect(state._options).to include option
    expect(state._defaults[option].value).to eq default_value unless default_value.nil?
  end
  description { "define option #{option}" }
  failure_message { |state| "expected #{state.class.name} to define option #{option}, #{for_default(default_value)}" }

  def for_default(default_value)
    return "without a default value" if default_value.nil?

    "with default value #{default_value}"
  end
end
