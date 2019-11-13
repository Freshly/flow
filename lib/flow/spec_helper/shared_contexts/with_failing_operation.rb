# frozen_string_literal: true

# Stubs a given flow to always fail when triggered.
#
# Usage:
#   describe SomeFlow do
#     let(:flow) { described_class.new }
#     let(:failing_flow_class) { described_class }
#
#     include_context "with failing operation"
#
#     before { flow.trigger }
#
#     it "is failed" do
#       expect(flow).to be_failed
#       expect(flow.failed_operation.operation_failure.problem).to eq failing_problem
#     end
#   end
#
# Requires let variables to be defined in the inclusion context:
# * failing_flow_class
#
# Defines the following variable:
# * failure_problem
RSpec.shared_context "with failing operation" do
  let(:failure_problem) { Faker::Lorem.words.join("-").parameterize.underscore }
  let(:failing_operation) do
    Class.new(Flow::OperationBase).tap do |klass|
      klass.__send__(:allow_direct_state_access)
      klass.instance_exec(self) do |spec_context|
        failure spec_context.failure_problem

        define_method :behavior do
          instance_eval("#{spec_context.failure_problem}_failure!")
        end
      end
    end
  end

  before do
    allow(failing_flow_class).to receive(:_operations).and_return([ failing_operation ])
    stub_const("FailingOperation", failing_operation)
  end
end
