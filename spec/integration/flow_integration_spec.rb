# frozen_string_literal: true

require_relative "../support/test_classes/bottle"
require_relative "../support/test_classes/count_out_current_bottles"
require_relative "../support/test_classes/pass_bottles_around"
require_relative "../support/test_classes/take_bottles_down"
require_relative "../support/test_classes/bottles_on_the_wall_state"
require_relative "../support/test_classes/bottles_on_the_wall_flow"

RSpec.describe Flow, type: :integration do
  include_context "with a bottles active record"

  subject(:flow) { BottlesOnTheWallFlow.trigger(**input) }

  let(:bottles_of) { "beer" }
  let(:number_to_take_down) { nil }
  let(:starting_bottles) { nil }
  let(:input) do
    {
      bottles_of: bottles_of,
      starting_bottles: starting_bottles,
      number_to_take_down: number_to_take_down,
    }.compact
  end

  shared_examples_for "a successful flow" do
    it { is_expected.to be_an_instance_of BottlesOnTheWallFlow }
    it { is_expected.to be_state_valid }
    it { is_expected.to be_state_validated }
    it { is_expected.not_to be_pending }
    it { is_expected.to be_triggered }
    it { is_expected.to be_success }
    it { is_expected.not_to be_failed }

    it "produces expected stanza" do
      expect(flow.outputs.stanza.join("\n")).to eq expected_stanza
    end
  end

  shared_examples_for "a failed flow" do |failed_operation_class, failure_problem|
    it { is_expected.to be_an_instance_of BottlesOnTheWallFlow }

    it { is_expected.to be_state_valid }
    it { is_expected.to be_state_validated }
    it { is_expected.not_to be_pending }
    it { is_expected.to be_triggered }
    it { is_expected.not_to be_success }
    it { is_expected.to be_failed }
    it { is_expected.to be_failed_operation }

    it "produces expected stanza" do
      expect(flow.state.stanza.join("\n")).to eq expected_stanza
    end

    describe "#failed_operation" do
      subject { flow.failed_operation }

      it { is_expected.to be_an_instance_of failed_operation_class }
      it { is_expected.to be_executed }
      it { is_expected.not_to be_success }
    end

    describe "#failed_operation#operation_failure" do
      subject { flow.failed_operation.operation_failure }

      it { is_expected.to be_an_instance_of Flow::Operation::Failures::OperationFailure }
    end

    describe "#failed_operation#operation_failure#problem" do
      subject { flow.failed_operation.operation_failure.problem }

      it { is_expected.to eq failure_problem }
    end
  end

  context "without bottles_of" do
    let(:bottles_of) { nil }

    it "raises" do
      expect { flow }.to raise_error ArgumentError, "Missing argument: bottles_of"
    end
  end

  context "with defaults" do
    let(:expected_string) { raw_string.delete("\n") }

    it_behaves_like "a successful flow" do
      let(:expected_stanza) do
        <<~STANZA.chomp
          99 bottles of beer on the wall, 99 bottles of beer.
          You take one down.
          You pass it around.
          98 bottles of beer on the wall.
        STANZA
      end
    end

    describe "#state#to_s" do
      subject { flow.state.to_s }

      let(:raw_string) do
        <<~STRING.chomp
          #<BottlesOnTheWallState bottles_of=beer starting_bottles= number_to_take_down=1 stanza=[
          "99 bottles of beer on the wall, 99 bottles of beer.",
           "You take one down.",
           "You pass it around.",
           "98 bottles of beer on the wall."
          ]
           unused=
          >
        STRING
      end

      it { is_expected.to eq expected_string }
    end

    describe "#state#inspect" do
      subject { flow.state.inspect }

      let(:raw_string) do
        <<~STRING.chomp
          #<BottlesOnTheWallState bottles_of="beer" starting_bottles=nil number_to_take_down=1 stanza=[
          "99 bottles of beer on the wall, 99 bottles of beer.",
           "You take one down.",
           "You pass it around.",
           "98 bottles of beer on the wall."
          ]
           unused=nil
          >
        STRING
      end

      it { is_expected.to eq expected_string }
    end
  end

  context "with starting_bottles" do
    context "when invalid" do
      let(:starting_bottles) { -1 }

      it "raises" do
        expect { flow }.to raise_error ActiveRecord::RecordInvalid,
                                       "Validation failed: Number on the wall must be greater than or equal to 0"
      end
    end

    context "when one" do
      let(:starting_bottles) { 1 }

      it_behaves_like "a successful flow" do
        let(:expected_stanza) do
          <<~STANZA.chomp
            1 bottle of beer on the wall, 1 bottle of beer.
            You take it down.
            You pass it around.
            No more bottles of beer on the wall.
          STANZA
        end
      end
    end

    context "when one million" do
      let(:starting_bottles) { 1_000_000 }

      it_behaves_like "a successful flow" do
        let(:expected_stanza) do
          <<~STANZA.chomp
            1000000 bottles of beer on the wall, 1000000 bottles of beer.
            You take one down.
            You pass it around.
            999999 bottles of beer on the wall.
          STANZA
        end
      end
    end
  end

  context "with number_to_take_down" do
    context "when invalid" do
      let(:number_to_take_down) { -1 }

      it "does not run" do
        expect { flow }.not_to change { Bottle.count }
      end

      it { is_expected.not_to be_state_valid }
      it { is_expected.to be_pending }
      it { is_expected.not_to be_triggered }
      it { is_expected.not_to be_success }
      it { is_expected.not_to be_failed }

      context "with trigger!" do
        subject(:trigger!) { BottlesOnTheWallFlow.trigger!(**input) }

        it "raises" do
          expect { trigger! }.to raise_error Flow::Errors::StateInvalid
        end
      end
    end

    context "when none" do
      let(:number_to_take_down) { 0 }

      it_behaves_like "a successful flow" do
        let(:expected_stanza) do
          <<~STANZA.chomp
            99 bottles of beer on the wall, 99 bottles of beer.
            You took nothing down.
            You pass nothing around.
            99 bottles of beer on the wall.
          STANZA
        end
      end
    end

    context "when many" do
      let(:number_to_take_down) { 3 }

      it_behaves_like "a successful flow" do
        let(:expected_stanza) do
          <<~STANZA.chomp
            99 bottles of beer on the wall, 99 bottles of beer.
            You take 3 down.
            You pass them around.
            96 bottles of beer on the wall.
          STANZA
        end
      end
    end

    context "when one million" do
      let(:starting_bottles) { 1_000_000 }

      it_behaves_like "a successful flow" do
        let(:expected_stanza) do
          <<~STANZA.chomp
            1000000 bottles of beer on the wall, 1000000 bottles of beer.
            You take one down.
            You pass it around.
            999999 bottles of beer on the wall.
          STANZA
        end
      end
    end
  end

  context "when number_to_take_down is greater than starting_bottles" do
    let(:starting_bottles) { 2 }
    let(:number_to_take_down) { 3 }

    it "raises" do
      expect { flow }.to raise_error ActiveRecord::RecordInvalid,
                                     "Validation failed: Number on the wall must be greater than or equal to 0"
    end
  end

  context "when the second operation fails" do
    let(:number_to_take_down) { 5 }

    it_behaves_like "a failed flow", TakeBottlesDown, :too_greedy do
      let(:expected_stanza) do
        <<~STANZA.chomp
          99 bottles of beer on the wall, 99 bottles of beer.
          Something went wrong! It's the end of the song, and there's 99 bottles of beer on the wall.
        STANZA
      end
    end
  end

  context "when the second operation fails proactively" do
    let(:bottles_of) { "tequila" }

    it_behaves_like "a failed flow", TakeBottlesDown, :too_dangerous do
      let(:expected_stanza) do
        <<~STANZA.chomp
          99 bottles of tequila on the wall, 99 bottles of tequila.
          Something went wrong! It's the end of the song, and there's 99 bottles of tequila on the wall.
        STANZA
      end
    end
  end

  context "when the third operation fails" do
    let(:number_to_take_down) { 4 }

    it_behaves_like "a failed flow", PassBottlesAround, :too_generous do
      let(:expected_stanza) do
        <<~STANZA.chomp
          99 bottles of beer on the wall, 99 bottles of beer.
          You take 4 down.
        STANZA
      end
    end
  end

  context "when the third operation fails by a known error" do
    let(:bottles) { Bottle.create(of: bottles_of, number_on_the_wall: starting_bottles) }
    let(:starting_bottles) { 4 }
    let(:number_to_take_down) { 3 }

    before { bottles.update!(number_passed_around: 99) }

    it_behaves_like "a failed flow", PassBottlesAround, :record_invalid do
      let(:expected_stanza) do
        <<~STANZA.chomp
          4 bottles of beer on the wall, 4 bottles of beer.
          You take 3 down.
          Passing the bottles wasn't as sound, now there's 3 on the ground!
        STANZA
      end
    end
  end

  context "when the third operation fails proactively" do
    let(:bottles_of) { "water" }

    it_behaves_like "a failed flow", PassBottlesAround, :not_dangerous_enough do
      let(:expected_stanza) do
        <<~STANZA.chomp
          99 bottles of water on the wall, 99 bottles of water.
          You take one down.
        STANZA
      end
    end
  end
end
