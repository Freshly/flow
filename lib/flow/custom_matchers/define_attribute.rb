# frozen_string_literal: true

# RSpec matcher that tests usage of `ApplicationState.attribute`
#
#     class ExampleState < ApplicationState
#       attribute :foo
#     end
#
#     RSpec.describe ExampleState, type: :state do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_attribute :foo }
#     end

RSpec::Matchers.define :define_attribute do |attribute|
  match { |state| expect(state._attributes).to include attribute }
  description { "define attribute #{attribute}" }
  failure_message { "expected #{described_class} to defines attribute #{attribute}" }
end
