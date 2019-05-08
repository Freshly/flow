# frozen_string_literal: true

RSpec.describe Flow::State::Arguments, type: :module do
  include_context "with an example state", described_class

  describe ".argument" do
    subject(:define_argument) { example_state_class.__send__(:argument, argument, allow_nil: allow_nil) }

    let(:argument) { Faker::Lorem.word.to_sym }
    let(:argument_value) do
      { allow_nil: allow_nil }
    end
    let(:allow_nil) { true }

    before { allow(example_state_class).to receive(:define_attribute).and_call_original }

    shared_examples_for "an argument is defined" do
      it "adds to _arguments" do
        expect { define_argument }.to change { example_state_class._arguments }.from({}).to(argument => argument_value)
      end

      it "defines an attribute" do
        define_argument
        expect(example_state_class).to have_received(:define_attribute).with(argument)
      end
    end

    context "with default options" do
      subject(:define_argument) { example_state_class.__send__(:argument, argument) }

      it_behaves_like "an argument is defined"
    end

    context "with allow_nil" do
      context "with allow_nil: true" do
        it_behaves_like "an argument is defined"
      end

      context "with allow_nil: false" do
        let(:allow_nil) { true }

        it_behaves_like "an argument is defined"
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :argument do
      let(:root_class) { example_state_class }
      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |argument, hash|
          hash[argument] = { allow_nil: true }
        end
      end
    end
  end

  describe ".after_initialize" do
    subject(:init) { example_class.new(**arguments) }

    let(:example_class) do
      Class.new do
        include Flow::State::Callbacks
        include Flow::State::Attributes
        include Flow::State::Core

        include Flow::State::Arguments

        argument :test_argument1
        argument :test_argument2
        argument :test_argument3, allow_nil: false
      end
    end

    context "when required nil arguments are provided" do
      let(:arguments) do
        { test_argument1: nil, test_argument2: nil, test_argument3: nil }
      end

      it "raises" do
        expect { init }.to raise_error ArgumentError, "Missing argument: test_argument3"
      end
    end

    context "when nil arguments are provided" do
      let(:arguments) do
        { test_argument1: nil, test_argument2: nil, test_argument3: :test_value3 }
      end

      it "does not raise" do
        expect { init }.not_to raise_error
      end
    end

    context "when arguments are provided" do
      let(:arguments) do
        { test_argument1: :test_value1, test_argument2: :test_value2, test_argument3: :test_value3 }
      end

      it "does not raise" do
        expect { init }.not_to raise_error
      end
    end

    context "when one argument is omitted" do
      let(:arguments) do
        { test_argument1: :test_value1, test_argument3: :test_value3 }
      end

      it "raises" do
        expect { init }.to raise_error ArgumentError, "Missing argument: test_argument2"
      end
    end

    context "when multiple arguments are omitted" do
      let(:arguments) do
        { test_argument3: :test_value3 }
      end

      it "does not raise" do
        expect { init }.to raise_error ArgumentError, "Missing arguments: test_argument1, test_argument2"
      end
    end
  end
end
