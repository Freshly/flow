# frozen_string_literal: true

# RSpec matcher that tests usage of `ApplicationState.output`
#
#     class ExampleState
#       output :foo
#       output :bar, default: :baz
#       output(:gaz) { :haz }
#     end
#
#     RSpec.describe ExampleState, type: :state do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_output :foo }
#       it { is_expected.to define_output :bar, :baz }
#       it { is_expected.to define_output :gaz, :haz }
#     end

RSpec::Matchers.define :define_output do |output, default_value = nil|
  match do |state|
    expect(state._defaults[output].value).to eq default_value unless default_value.nil?
    expect(state._outputs).to include output
  end
  description { "define output outputoption}" }
  failure_message { |state| "expected #{state.class.name} to define output #{output} #{for_default(default_value)}" }

  def for_default(default_value)
    return "without a default value" if default_value.nil?

    "with default value #{default_value}"
  end
end
