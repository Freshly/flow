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
#       it { is_expected.to define_output :bar, default: :baz }
#       it { is_expected.to define_output :gaz, default: :haz }
#     end

RSpec::Matchers.define :define_output do |output, default: nil|
  match do |state|
    expect(state._defaults[output]&.value).to eq default
    expect(state._outputs).to include output
  end
  description { "define output" }
  failure_message { "expected #{described_class} to define output #{output} #{for_default(default)}" }

  def for_default(default)
    return "without a default value" if default.nil?

    "with default value #{default}"
  end
end
