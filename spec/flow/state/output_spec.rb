# frozen_string_literal: true

RSpec.describe Flow::State::Output, type: :concern do
  include_context "with an example state"

  describe ".output" do
    it_behaves_like "an input object with a class collection attribute", :output, :_outputs do
      let(:example_input_object_class) { example_state_class }
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :output do
      let(:root_class) { example_state_class }
    end
  end

  shared_context "with example state having output" do
    let(:example_state) { example_class.new }
    let(:example_class) do
      Class.new(example_state_class) do
        output :test_output0
        output :test_output1, default: :default_value1
        output(:test_output2) { :default_value2 }
      end
    end

    before do
      stub_const(Faker::Internet.unique.domain_word.underscore.capitalize, example_state_class)
      stub_const(Faker::Internet.unique.domain_word.underscore.capitalize, example_class)
    end
  end

  describe ".after_validation" do
    include_context "with example state having output"

    subject(:valid?) { example_state.valid? }

    shared_examples_for "can't read or write output" do
      it "raises on attempted write" do
        expect { example_state.test_output0 = :test }.to raise_error Flow::NotValidatedError
        expect { example_state.test_output1 = :test }.to raise_error Flow::NotValidatedError
        expect { example_state.test_output2 = :test }.to raise_error Flow::NotValidatedError
      end

      it "raises on attempted read" do
        expect { example_state.test_output0 }.to raise_error Flow::NotValidatedError
        expect { example_state.test_output1 }.to raise_error Flow::NotValidatedError
        expect { example_state.test_output2 }.to raise_error Flow::NotValidatedError
      end
    end

    context "without running validations" do
      it_behaves_like "can't read or write output"
    end

    context "with validation errors" do
      before do
        example_class.__send__(:define_attribute, :name)
        example_class.validates :name, presence: true
        valid?
      end

      it_behaves_like "can't read or write output"
    end

    context "without validation errors" do
      it "sets default values" do
        valid?

        expect(example_state.test_output1).to eq :default_value1
        expect(example_state.test_output2).to eq :default_value2
      end

      it "allows read/write of output" do
        valid?

        expect { example_state.test_output0 = :x }.to change { example_state.test_output0 }.from(nil).to(:x)
        expect { example_state.test_output1 = :y }.to change { example_state.test_output1 }.from(:default_value1).to(:y)
        expect { example_state.test_output2 = :z }.to change { example_state.test_output2 }.from(:default_value2).to(:z)
      end
    end

    context "when run twice after output set" do
      it "allows read/write of output" do
        valid?

        expect { example_state.test_output1 = :y }.to change { example_state.test_output1 }.from(:default_value1).to(:y)

        # can't use subject cause it's memoized
        expect { example_state.valid? }.not_to change { example_state.test_output1 }
      end
    end
  end

  describe "#outputs" do
    subject(:outputs) { example_state.outputs }

    context "without any outputs" do
      it { is_expected.to eq({}) }
    end

    context "with outputs" do
      include_context "with example state having output"

      context "without running validations" do
        it "raises" do
          expect { example_state.outputs }.to raise_error Flow::NotValidatedError
        end
      end

      context "when valid" do
        let(:expected_hash) do
          { test_output0: nil, test_output1: :default_value1, test_output2: :default_value2 }
        end

        before { example_state.valid? }

        it { is_expected.to have_attributes(**expected_hash) }
      end
    end
  end
end
