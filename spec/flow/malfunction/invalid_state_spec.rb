# frozen_string_literal: true

RSpec.describe Flow::Malfunction::InvalidState, type: :malfunction do
  include_context "with an example state"

  subject(:malfunction) { described_class.new(example_state) }

  it { is_expected.to inherit_from Flow::Malfunction::Base }

  it { is_expected.to have_prototype_name "InvalidState" }

  it { is_expected.to use_attribute_errors }
  it { is_expected.to contextualize_as :state }

  it { is_expected.to delegate_method(:errors).to(:state).with_prefix }

  describe "#build" do
    subject(:_build) { malfunction.build }

    let(:input) { Hash[:foo, 0.1] }
    let(:example_state_class) do
      Class.new(Flow::StateBase) do
        argument :foo
        option :bar

        validates :foo, numericality: { only_integer: true }
        validates :bar, presence: true
      end
    end
    let(:expected_attribute_errors) { [ foo_numericality_error, bar_presence_error ] }
    let(:foo_numericality_error) do
      Malfunction::AttributeError.new(attribute_name: :foo, error_code: :not_an_integer, message: "must be an integer")
    end
    let(:bar_presence_error) do
      Malfunction::AttributeError.new(attribute_name: :bar, error_code: :blank, message: "can't be blank")
    end

    before { example_state.valid? }

    it "sets attribute errors" do
      expect { _build }.to change { malfunction.attribute_errors }.to(array_including(*expected_attribute_errors))
    end
  end
end
