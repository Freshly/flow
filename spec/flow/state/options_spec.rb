# frozen_string_literal: true

RSpec.describe Flow::State::Options, type: :module do
  include_context "with an example state"

  describe ".option" do
    let(:option) { Faker::Lorem.word.to_sym }

    context "with output option" do
      subject(:define_option) { example_state_class.__send__(:option, option, output: output) }

      context "with output:true" do
        let(:output) { true }

        it "adds to _outputs" do
          expect { define_option }.to change { example_state_class._outputs }.from([]).to([option])
        end

        it "adds to _options" do
          expect { define_option }.to change { example_state_class._options }.from([]).to([option])
        end
      end

      context "with output:false" do
        let(:output) { false }

        it "does not add to _outputs" do
          expect { define_option }.to_not change { example_state_class._outputs }.from([])
        end

        it "adds to _options" do
          expect { define_option }.to change { example_state_class._options }.from([]).to([option])
        end
      end
    end

    context "without output option" do
      subject(:define_option) { example_state_class.__send__(:option, option) }

      it "does not add to _outputs" do
        expect { define_option }.to_not change { example_state_class._outputs }.from([])
      end

      it "adds to _options" do
        expect { define_option }.to change { example_state_class._options }.from([]).to([option])
      end
    end
  end

  describe "#outputs" do
    subject(:outputs) { example_state.outputs }

    let(:example_state) { example_class.new }

    before do
      stub_const(Faker::Internet.unique.domain_word.underscore.capitalize, example_state_class)
      stub_const(Faker::Internet.unique.domain_word.underscore.capitalize, example_class)
    end

    context "when arguments are defined as outputs" do
      let(:example_class) do
        Class.new(example_state_class) do
          option :test_option0, output: true
          option :test_option1, default: :default_value1, output: true
          option(:test_option2, output: true) { :default_value2 }
        end
      end
      let(:expected_outputs) { { test_option0: nil, test_option1: :default_value1, test_option2: :default_value2 } }

      it { is_expected.to have_attributes(**expected_outputs) }
    end

    context "when arguments are NOT defined as outputs" do
      let(:example_class) do
        Class.new(example_state_class) do
          option :test_option0
          option :test_option1, default: :default_value1
          option(:test_option2) { :default_value2 }
        end
      end

      it { is_expected.to be_blank }
    end
  end
end
