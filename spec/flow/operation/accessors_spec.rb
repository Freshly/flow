# frozen_string_literal: true

RSpec.describe Flow::Operation::Accessors, type: :module do
  include_context "with an example operation"

  let(:operation_class) { example_operation_class }
  let(:state_attribute) { Faker::Lorem.unique.word.to_sym }
  let(:state_attributes) { [ state_attribute ] }
  let(:state_attribute_writer) { "#{state_attribute}=".to_sym }
  let(:state_attribute_value) { Faker::Hipster.word }
  let(:definition_options) { {} }
  let(:prefix) { false }

  shared_context "with prefix option set" do
    let(:definition_options) { { prefix: prefix } }
    let(:prefix_name) { (prefix == true ? :state : prefix).to_sym }
  end

  shared_context "when multiple method names are given" do
    let(:other_state_attribute) { Faker::Lorem.unique.word.to_sym }
    let(:state_attributes) { [ state_attribute, other_state_attribute ] }
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

  shared_examples_for "it defines delegated readers for all methods" do
    it "defines readers for each method" do
      state_attributes.each do |attr|
        if prefix
          expect(operation).to delegate_method(attr).to(:state).with_prefix(prefix_name)
        else
          expect(operation).to delegate_method(attr).to(:state)
        end
      end
    end
  end

  shared_examples_for "it defines delegated writers for all methods" do
    it "defines writers for each method" do
      state_attributes.each do |attr|
        if prefix
          expect(operation).to delegate_method("#{attr}=".to_sym).to(:state).with_prefix(prefix_name).with_arguments(state_attribute_value)
        else
          expect(operation).to delegate_method("#{attr}=".to_sym).to(:state).with_arguments(state_attribute_value)
        end
      end
    end
  end

  describe ".state_reader" do
    subject(:operation) do
      operation_class.__send__(:state_reader, *state_attributes, **definition_options)
      operation_class.new(example_state)
    end

    it_behaves_like "it inherits correctly", :state_reader, :reader

    it { is_expected.to delegate_method(state_attribute).to(:state) }

    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when multiple method names are given" do
      include_context "when multiple method names are given"

      it_behaves_like "it defines delegated readers for all methods"
    end

    context "when prefix is given" do
      include_context "with prefix option set"

      context "when prefix is true" do
        let(:prefix) { true }

        it_behaves_like "it has exactly one tracker variable of type", :reader

        it { is_expected.to delegate_method(state_attribute).to(:state).with_prefix(prefix_name) }

        context "when multiple method names are given" do
          include_context "when multiple method names are given"

          it_behaves_like "it defines delegated readers for all methods"
        end
      end

      context "when prefix is a string" do
        let(:prefix) { Faker::Lorem.unique.word }

        it_behaves_like "it has exactly one tracker variable of type", :reader

        it { is_expected.to delegate_method(state_attribute).to(:state).with_prefix(prefix_name) }

        context "when multiple method names are given" do
          include_context "when multiple method names are given"

          it_behaves_like "it defines delegated readers for all methods"
        end
      end
    end

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
      operation_class.__send__(:state_writer, *state_attributes, **definition_options)
      operation_class.new(example_state)
    end

    it_behaves_like "it inherits correctly", :state_writer, :writer

    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when multiple method names are given" do
      include_context "when multiple method names are given"

      it_behaves_like "it defines delegated writers for all methods"
    end

    context "when prefix is given" do
      include_context "with prefix option set"

      context "when prefix is true" do
        let(:prefix) { true }

        it_behaves_like "it has exactly one tracker variable of type", :writer

        it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_prefix(prefix_name).with_arguments(state_attribute_value) }

        context "when multiple method names are given" do
          include_context "when multiple method names are given"

          it_behaves_like "it defines delegated writers for all methods"
        end
      end

      context "when prefix is a string" do
        let(:prefix) { Faker::Lorem.unique.word }

        it_behaves_like "it has exactly one tracker variable of type", :writer

        it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_prefix(prefix_name).with_arguments(state_attribute_value) }

        context "when multiple method names are given" do
          include_context "when multiple method names are given"

          it_behaves_like "it defines delegated writers for all methods"
        end
      end
    end

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a reader has already been defined" do
      before { operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_accessor" do
    subject(:operation) do
      operation_class.__send__(:state_accessor, *state_attributes, **definition_options)
      operation_class.new(example_state)
    end

    it_behaves_like "it inherits correctly", :state_accessor, %i[reader writer accessor]

    it { is_expected.to delegate_method(state_attribute).to(:state) }
    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has exactly one tracker variable of type", :accessor

    context "when multiple method names are given" do
      include_context "when multiple method names are given"

      it_behaves_like "it defines delegated readers for all methods"
      it_behaves_like "it defines delegated writers for all methods"
    end

    context "when prefix is given" do
      include_context "with prefix option set"

      context "when prefix is true" do
        let(:prefix) { true }

        it_behaves_like "it has exactly one tracker variable of type", :reader
        it_behaves_like "it has exactly one tracker variable of type", :writer
        it_behaves_like "it has exactly one tracker variable of type", :accessor

        it { is_expected.to delegate_method(state_attribute).to(:state).with_prefix(prefix_name) }
        it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_prefix(prefix_name).with_arguments(state_attribute_value) }

        context "when multiple method names are given" do
          include_context "when multiple method names are given"

          it_behaves_like "it defines delegated readers for all methods"
          it_behaves_like "it defines delegated writers for all methods"
        end
      end

      context "when prefix is a string" do
        let(:prefix) { Faker::Lorem.unique.word }

        it_behaves_like "it has exactly one tracker variable of type", :reader
        it_behaves_like "it has exactly one tracker variable of type", :writer
        it_behaves_like "it has exactly one tracker variable of type", :accessor

        it { is_expected.to delegate_method(state_attribute).to(:state).with_prefix(prefix_name) }
        it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_prefix(prefix_name).with_arguments(state_attribute_value) }

        context "when multiple method names are given" do
          include_context "when multiple method names are given"

          it_behaves_like "it defines delegated readers for all methods"
          it_behaves_like "it defines delegated writers for all methods"
        end
      end
    end

    context "when a writer has already been defined" do
      before { operation_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end

    context "when a reader has already been defined" do
      before { operation_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end
end
