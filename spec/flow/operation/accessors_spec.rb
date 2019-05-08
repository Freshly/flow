# frozen_string_literal: true

RSpec.describe Flow::Operation::Accessors, type: :module do
  include_context "with an example operation", described_class

  let(:state_attribute) { Faker::Lorem.word.to_sym }
  let(:state_attribute_writer) { "#{state_attribute}=".to_sym }
  let(:state_attribute_value) { Faker::Hipster.word }

  before do
    state.attr_accessor(state_attribute)
  end

  shared_examples_for "it has exactly ? of type" do |count, tracker_type|
    subject { operation.public_send(tracker_name).count(state_attribute) }

    let(:tracker_name) { "_state_#{tracker_type}".pluralize }

    it { is_expected.to eq count }
  end

  shared_examples_for "it has exactly one tracker variable of type" do |tracker_type|
    it_behaves_like "it has exactly ? of type", 1, tracker_type
  end

  shared_examples_for "it has no tracker variables of type" do |tracker_type|
    it_behaves_like "it has exactly ? of type", 0, tracker_type
  end

  describe ".state_reader" do
    subject(:operation) do
      example_operation_class.__send__(:state_reader, state_attribute)
      example_operation_class.new(state)
    end

    it { is_expected.to delegate_method(state_attribute).to(:state) }

    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when a reader has already been defined" do
      before { example_operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a writer has already been defined" do
      before { example_operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_writer" do
    subject(:operation) do
      example_operation_class.__send__(:state_writer, state_attribute)
      example_operation_class.new(state)
    end

    before { example_operation_class.__send__(:state_writer, state_attribute) }

    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when a writer has already been defined" do
      before { example_operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a writer has already been defined" do
      before { example_operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_accessor" do
    subject(:operation) do
      example_operation_class.__send__(:state_accessor, state_attribute)
      example_operation_class.new(state)
    end

    before { example_operation_class.__send__(:state_accessor, state_attribute) }

    it { is_expected.to delegate_method(state_attribute).to(:state) }
    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has exactly one tracker variable of type", :accessor

    context "when a writer has already been defined" do
      before { example_operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end

    context "when a writer has already been defined" do
      before { example_operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end
end
