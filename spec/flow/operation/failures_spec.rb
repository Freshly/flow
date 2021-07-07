# frozen_string_literal: true

RSpec.describe Flow::Operation::Failures, type: :concern do
  include_context "with an example operation"

  let(:problem) { Faker::Lorem.word.to_sym }

  describe ".failure" do
    subject(:define_failure) { example_operation_class.__send__(:failure, problem) }

    it "adds to _failures" do
      expect { define_failure }.to change { example_operation_class._failures }.from([]).to([ problem ])
    end

    it "defines a callback" do
      expect { define_failure }.
        to change { example_operation_class.__callbacks.keys.include? problem }.
        from(false).
        to(true)
    end

    it "defines #on_<problem>_failure" do
      expect { define_failure }.
        to change { example_operation_class.respond_to?("on_#{problem}_failure".to_sym) }.
        from(false).
        to(true)
    end

    it "defines #<problem>_failure!" do
      expect { define_failure }.
        to change { example_operation_class.method_defined?("#{problem}_failure!".to_sym) }.
        from(false).
        to(true)
    end

    shared_examples_for "a before execute callback is defined" do |method|
      subject(:define_failure) { example_operation_class.__send__(:failure, problem, **options) }

      before { allow(example_operation_class).to receive(:set_callback).and_call_original }

      let(:options) do
        {}.tap do |hash|
          hash[method] = proc { true }
        end
      end
      let(:expected_options) do
        {}.tap { |hash| hash[method] = instance_of(Proc) }
      end

      before { define_failure }

      it "defines a callback" do
        expect(example_operation_class).
          to have_received(:set_callback).
          with(:execute, :before, instance_of(Proc), **expected_options)
      end
    end

    context "when if: conditional is given" do
      it_behaves_like "a before execute callback is defined", :if
    end

    context "when unless: conditional is given" do
      it_behaves_like "a before execute callback is defined", :unless
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :failure do
      let(:root_class) { example_operation_class }
    end
  end

  describe "#on_<problem>_failure" do
    subject(:failure) { example_operation.run_callbacks(problem) }

    before do
      example_operation_class.__send__(:failure, problem)
      example_operation_class.attr_accessor :before_hook_run
      example_operation_class.public_send("on_#{problem}_failure".to_sym) { self.before_hook_run = true }
    end

    it "runs callback on failure" do
      expect { failure }.to change { example_operation.before_hook_run }.from(nil).to(true)
    end
  end

  describe "#<problem>_failure!" do
    subject(:problem_failure!) { example_operation.public_send("#{problem}_failure!".to_sym, **details) }

    let(:details) { Hash[*Faker::Lorem.words(number: 4)].symbolize_keys }

    before do
      example_operation_class.__send__(:failure, problem)

      allow(example_operation).to receive(:fail!)
    end

    it "calls fail!" do
      problem_failure!
      expect(example_operation).to have_received(:fail!).with(problem, **details)
    end
  end

  describe "#fail!" do
    subject(:fail!) { example_operation.fail!(problem, **details) }

    let(:details) { Hash[*Faker::Lorem.words(number: 4)].symbolize_keys }

    before do
      allow(example_operation).to receive(:error!).and_call_original

      example_operation_class.__send__(:failure, problem)
      example_operation_class.attr_accessor :before_failure_hook_run, :before_problem_hook_run
      example_operation_class.public_send(:on_failure) { self.before_failure_hook_run = true }
      example_operation_class.public_send("on_#{problem}_failure".to_sym) { self.before_problem_hook_run = true }
    end

    it "logs, raises, and runs callbacks" do
      expect { fail! }.to raise_error(Flow::Operation::Failures::OperationFailure, problem.to_s).
        and change { example_operation.before_failure_hook_run }.from(nil).to(true).
        and change { example_operation.before_problem_hook_run }.from(nil).to(true)

      expect(example_operation).
        to have_received(:error!).with(instance_of(Flow::Operation::Failures::OperationFailure), **details)
    end

    it "has the problem details" do
      fail!
    rescue Flow::Operation::Failures::OperationFailure => operation_failure
      expect(operation_failure.problem).to eq problem
      expect(operation_failure.details).to eq OpenStruct.new(details)
    end
  end
end
