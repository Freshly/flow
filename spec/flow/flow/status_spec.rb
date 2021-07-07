# frozen_string_literal: true

RSpec.describe Flow::Flow::Status, type: :concern do
  include_context "with example flow having state"

  shared_examples_for "a flow status driven by array presence" do |status_method, array_method, true_if_empty = false|
    subject { example_flow.public_send(status_method) }

    context "without empty array_method" do
      it { is_expected.to be true_if_empty }
    end

    context "with a present array_method" do
      before { example_flow.__send__(array_method) << :operation }

      it { is_expected.to be !true_if_empty }
    end
  end

  describe "#pending?" do
    it_behaves_like "a flow status driven by array presence", :pending?, :executed_operations, true
  end

  describe "#triggered?" do
    it_behaves_like "a flow status driven by array presence", :triggered?, :executed_operations
  end

  describe "#failed?" do
    subject(:failed?) { example_flow.failed? }

    before do
      allow(example_flow).to receive(:triggered?).and_return(triggered?)
      allow(example_flow).to receive(:success?).and_return(success?)
    end

    context "when neither triggered? nor success?" do
      let(:triggered?) { false }
      let(:success?) { false }

      it { is_expected.to be false }
    end

    context "when triggered? but not success?" do
      let(:triggered?) { true }
      let(:success?) { false }

      it { is_expected.to be true }
    end

    context "when triggered? and success?" do
      let(:triggered?) { true }
      let(:success?) { true }

      it { is_expected.to be false }
    end
  end

  describe "#success?" do
    subject(:success?) { example_flow.success? }

    context "with no operation_instances nor executed_operations" do
      it { is_expected.to be false }
    end

    context "when operation_instances matches executed_operations" do
      before do
        example_flow.__send__(:operation_instances) << :operation
        example_flow.__send__(:executed_operations) << :operation
      end

      it { is_expected.to be true }
    end

    context "when operation_instances DOES NOT match executed_operations" do
      before do
        example_flow.__send__(:operation_instances) << :operation
        example_flow.__send__(:executed_operations) << :operation1
      end

      it { is_expected.to be false }
    end
  end

  describe "#malfunction?" do
    subject { example_flow }

    context "with malfunction" do
      let(:malfunction) { instance_double(Flow::Malfunction::Base) }

      before { allow(example_flow).to receive(:malfunction).and_return(malfunction) }

      it { is_expected.to be_malfunction }
    end

    context "without malfunction" do
      it { is_expected.not_to be_malfunction }
    end
  end
end
