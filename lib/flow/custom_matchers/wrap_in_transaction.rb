# frozen_string_literal: true

# RSpec matcher that tests usage of `.wrap_in_transaction` for `ApplicationFlow` or `ApplicationOperation`
#
#     class ExampleFlow
#       wrap_in_transaction
#       operations OperationOne, OperationTwo
#     end
#
#     class ExampleState
#       wrap_in_transaction
#     end
#
#     RSpec.describe ExampleFlow, type: :flow do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to wrap_in_transaction }
#     end
#
#     RSpec.describe Example, type: :operation do
#       subject(:operation) { described_class.new(state) }
#
#       let(:state) { example_state_class.new(**state_input) }
#       let(:example_state_class) { Class.new(ApplicationState) }
#       let(:state_input) do
#         {}
#       end
#
#       it { is_expected.to wrap_in_transaction }
#     end

# rubocop:disable Metrics/BlockLength
RSpec::Matchers.define :wrap_in_transaction do
  match do |instance|
    callback_name = instance.class.callback_name
    original_transaction_count = instance.class.transaction_provider.connection.open_transactions

    allow(instance).to receive(callback_name) do
      expect(instance.class.transaction_provider.connection.open_transactions).to eq original_transaction_count + 1
    end

    instance.run_callbacks(callback_name) { instance.public_send(callback_name) }
    expect(instance).to have_received(callback_name)
  end

  description do
    "wrap in a transaction"
  end

  failure_message do |instance|
    "expected #{instance.class.name} to wrap in a transaction"
  end

  def pretty_callbacks(callbacks)
    callbacks.join(", ")
  end
end
# rubocop:enable Metrics/BlockLength
