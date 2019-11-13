# frozen_string_literal: true

RSpec.shared_context "with an example operation" do |extra_operation_modules = nil|
  subject(:example_operation) { example_operation_class.new(state) }

  let(:root_operation_modules) { [ ShortCircuIt, Technologic, Flow::Operation::Callbacks, Flow::Operation::Core ] }
  let(:operation_modules) { root_operation_modules + Array.wrap(extra_operation_modules) }

  let(:root_operation_class) { Class.new }
  let(:example_operation_class) do
    root_operation_class.tap do |operation_class|
      operation_modules.each { |operation_module| operation_class.include operation_module }
      operation_class.__send__(:allow_direct_state_access) if direct_state_access?
    end
  end

  let(:direct_state_access?) { true }

  let(:state) { Class.new(Flow::StateBase) }
end
