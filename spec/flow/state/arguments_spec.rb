# frozen_string_literal: true

RSpec.describe Flow::State::Arguments, type: :module do
  include_context "with an example state"

  describe ".argument" do
    let(:argument) { Faker::Lorem.word.to_sym }

    context "with output option" do
      subject(:define_argument) { example_state_class.__send__(:argument, argument, output: output) }

      context "with output:true" do
        let(:output) { true }

        it "adds to _outputs" do
          expect { define_argument }.to change { example_state_class._outputs }.from([]).to([argument])
        end

        it "adds to _arguments" do
          expect { define_argument }.to change { example_state_class._arguments }.from({}).to(argument => { allow_nil: true })
        end
      end

      context "with output:false" do
        let(:output) { false }

        it "does not add to _outputs" do
          expect { define_argument }.to_not change { example_state_class._outputs }.from([])
        end

        it "adds to _arguments" do
          expect { define_argument }.to change { example_state_class._arguments }.from({}).to(argument => { allow_nil: true })
        end
      end
    end

    context "without output option" do
      subject(:define_argument) { example_state_class.__send__(:argument, argument) }

      it "does not add to _outputs" do
        expect { define_argument }.to_not change { example_state_class._outputs }.from([])
      end

      it "adds to _arguments" do
        expect { define_argument }.to change { example_state_class._arguments }.from({}).to(argument => { allow_nil: true })
      end
    end
  end

  describe "#outputs" do
    subject(:outputs) { example_state.outputs }

    let(:example_state) { example_class.new(state_inputs) }
    let(:state_inputs) do
      { test_argument0: nil, test_argument1: :input_value1, test_argument2: :input_value2 }
    end

    before do
      stub_const(Faker::Internet.unique.domain_word.underscore.capitalize, example_state_class)
      stub_const(Faker::Internet.unique.domain_word.underscore.capitalize, example_class)
    end

    context "when arguments are defined as outputs" do
      let(:example_class) do
        Class.new(example_state_class) do
          argument :test_argument0, output: true
          argument :test_argument1, output: true
          argument :test_argument2, output: true
        end
      end

      it { is_expected.to have_attributes(**state_inputs) }
    end

    context "when arguments are NOT defined as outputs" do
      let(:example_class) do
        Class.new(example_state_class) do
          argument :test_argument0
          argument :test_argument1
          argument :test_argument2
        end
      end

      it { is_expected.to be_blank }
    end
  end
end
