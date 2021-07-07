# frozen_string_literal: true

RSpec.describe Flow::State::Status, type: :concern do
  include_context "with an example state"

  describe "#validated?" do
    subject { example_state.validated? }

    before { stub_const(Faker::Internet.domain_word.underscore.camelize, example_state_class) }

    it { is_expected.to be false }

    context "when callbacks run" do
      subject { -> { example_state.valid? } }

      context "with errors" do
        before do
          example_state_class.__send__(:define_attribute, :name)
          example_state_class.validates :name, presence: true
        end

        it { is_expected.not_to change { example_state.validated? }.from(false) }
      end

      context "without errors" do
        it { is_expected.to change { example_state.validated? }.from(false).to(true) }
      end
    end
  end
end
