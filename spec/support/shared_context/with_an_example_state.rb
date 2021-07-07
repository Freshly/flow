# frozen_string_literal: true

RSpec.shared_context "with an example state" do
  subject(:example_state) { example_state_class.new(**input) }

  let(:example_state_class) { Class.new(Flow::StateBase) }

  let(:input) { {} }

  let(:example_name) { Faker::Internet.domain_word.underscore.capitalize }
  let(:example_state_name) { "#{example_name}State" }

  before { stub_const(example_state_name, example_state_class) }
end
