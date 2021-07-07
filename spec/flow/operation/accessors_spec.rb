# frozen_string_literal: true

RSpec.describe Flow::Operation::Accessors, type: :concern do
  include_context "with an example operation"

  let(:operation_class) { example_operation_class }
  let(:state_attribute) { Faker::Lorem.word.to_sym }
  let(:state_attribute_writer) { "#{state_attribute}=".to_sym }
  let(:state_attribute_value) { Faker::Hipster.word }

  before { example_state_class.attr_accessor(state_attribute) }

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

  shared_examples_for "it inherits correctly" do |method, accessor_types|
    subject(:operation) { operation_class.new(example_state) }

    Array.wrap(accessor_types).each do |accessor_type|
      context "when a #{method} is defined in a child class" do
        let(:child_class) { Class.new(operation_class) }

        before { child_class.__send__(method, state_attribute) }

        it_behaves_like "it has no tracker variables of type", accessor_type
      end
    end

    Array.wrap(accessor_types).each do |accessor_type|
      context "when a #{method} is defined in a sibling class" do
        let(:operation_class) { Class.new(example_operation_class) }
        let(:sibling_class) { Class.new(example_operation_class) }

        before { sibling_class.__send__(method, state_attribute) }

        it_behaves_like "it has no tracker variables of type", accessor_type
      end
    end

    Array.wrap(accessor_types).each do |accessor_type|
      context "when a #{method} is defined in a parent class" do
        let(:operation_class) { Class.new(example_operation_class) }

        before { operation_class.__send__(method, state_attribute) }

        it_behaves_like "it has exactly one tracker variable of type", accessor_type
      end
    end
  end

  describe ".state_reader" do
    subject(:operation) do
      operation_class.__send__(:state_reader, state_attribute)
      operation_class.new(example_state)
    end

    it_behaves_like "it inherits correctly", :state_reader, :reader

    it { is_expected.to delegate_method(state_attribute).to(:state) }

    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when a reader has already been defined" do
      before { operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_writer" do
    subject(:operation) do
      operation_class.__send__(:state_writer, state_attribute)
      operation_class.new(example_state)
    end

    it_behaves_like "it inherits correctly", :state_writer, :writer

    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_accessor" do
    subject(:operation) do
      operation_class.__send__(:state_accessor, state_attribute)
      operation_class.new(example_state)
    end

    it_behaves_like "it inherits correctly", :state_accessor, %i[reader writer accessor]

    it { is_expected.to delegate_method(state_attribute).to(:state) }
    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has exactly one tracker variable of type", :accessor

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end
end
