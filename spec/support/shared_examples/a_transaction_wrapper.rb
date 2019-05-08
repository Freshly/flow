# frozen_string_literal: true

RSpec.shared_examples_for "a transaction wrapper" do
  it { is_expected.to include_module Flow::TransactionWrapper }

  let(:transaction_provider) { ActiveRecord::Base }

  describe ".transaction_provider" do
    subject { example_class.__send__(:transaction_provider) }

    it { is_expected.to eq transaction_provider }
  end
end
