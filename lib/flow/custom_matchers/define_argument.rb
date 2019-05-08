# frozen_string_literal: true

# RSpec matcher that tests usage of `ApplicationState.argument`
#
#     class ExampleState < ApplicationState
#       argument :foo
#       argument :bar, allow_nil: false
#     end
#
#     RSpec.describe ExampleState, type: :state do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_argument :foo }
#       it { is_expected.to define_argument :bar, allow_nil: false }
#     end

RSpec::Matchers.define :define_argument do |argument, allow_nil: true|
  match { |state| expect(state._arguments[argument]).to eq(allow_nil: allow_nil) }
  description { "define argument #{argument}" }
  failure_message { "expected #{described_class} to define argument #{argument} #{prohibit_nil_description unless allow_nil}" }

  def prohibit_nil_description
    "and prohibit a nil value"
  end
end
