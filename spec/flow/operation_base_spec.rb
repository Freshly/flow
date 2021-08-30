# frozen_string_literal: true

RSpec.describe Flow::OperationBase, type: :operation do
  subject { described_class }

  it { is_expected.to inherit_from Flow::RootObject }

  it { is_expected.to include_module Flow::TransactionWrapper }
  it { is_expected.to include_module Flow::Operation::Accessors }
  it { is_expected.to include_module Flow::Operation::Callbacks }
  it { is_expected.to include_module Flow::Operation::Core }
  it { is_expected.to include_module Flow::Operation::Execute }
  it { is_expected.to include_module Flow::Operation::Failures }
  it { is_expected.to include_module Flow::Operation::ErrorHandler }
  it { is_expected.to include_module Flow::Operation::Status }
  it { is_expected.to include_module Flow::Operation::Transactions }
end
