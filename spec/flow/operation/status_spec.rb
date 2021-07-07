# frozen_string_literal: true

RSpec.describe Flow::Operation::Status, type: :concern do
  include_context "with an example operation"

  shared_examples_for "a callback tracking predicate" do |callback, predicate|
    subject { example_operation.public_send(predicate) }

    it { is_expected.to be false }

    context "when callbacks run" do
      subject { -> { example_operation.run_callbacks(callback) } }

      it { is_expected.to change { example_operation.public_send(predicate) }.from(false).to(true) }
    end
  end

  describe "#executed?" do
    it_behaves_like "a callback tracking predicate", :execute, :executed?
  end

  describe "#failed?" do
    subject(:failed?) { example_operation.failed? }

    it { is_expected.to be false }

    context "when there is an operation failure" do
      before do
        example_operation.instance_variable_set(:@operation_failure, Flow::Operation::Failures::OperationFailure.new)
      end

      it { is_expected.to eq true }
    end
  end

  describe "#success?" do
    subject(:success?) { example_operation.success? }

    it { is_expected.to be false }

    context "when executed?" do
      before do
        allow(example_operation).to receive(:executed?).and_return(true)
        allow(example_operation).to receive(:failed?).and_return(failed?)
      end

      context "when NOT failure?" do
        let(:failed?) { false }

        it { is_expected.to be true }
      end

      context "when failure?" do
        let(:failed?) { true }

        it { is_expected.to be false }
      end
    end
  end
end
