# frozen_string_literal: true

RSpec.shared_context "with operations for a flow" do
  # These intentionally do not use allow_direct_state_access to ensure the deprecation is tested
  let(:operation0_class) { Class.new(Flow::OperationBase) }
  let(:operation1_class) { Class.new(Flow::OperationBase) }
  let(:operation2_class) { Class.new(Flow::OperationBase) }
  let(:operation0_name) { Faker::Internet.unique.domain_word.capitalize }
  let(:operation1_name) { Faker::Internet.unique.domain_word.capitalize }
  let(:operation2_name) { Faker::Internet.unique.domain_word.capitalize }
  let(:operation_classes) { [ operation0_class, operation1_class, operation2_class ] }
  let(:instance_of_operations) do
    operation_classes.map { |operation| instance_of(operation) }
  end
  let(:operations) do
    operation_classes.map { |operation_class| operation_class.new(state) }
  end

  let(:state) { instance_double(example_state_class) }

  before do
    stub_const(operation0_name, operation0_class)
    stub_const(operation1_name, operation1_class)
    stub_const(operation2_name, operation2_class)

    allow(example_flow).to receive(:state).and_return(state)
  end
end
