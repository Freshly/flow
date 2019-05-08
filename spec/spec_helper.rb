require "bundler/setup"
require "simplecov"

require "rspice"
require "shoulda-matchers"

require_relative "../lib/flow/spec_helper"

require_relative "support/shared_context/with_a_bottles_active_record"
require_relative "support/shared_context/with_an_example_state"
require_relative "support/shared_context/with_an_example_operation"
require_relative "support/shared_context/with_example_flow_having_state"
require_relative "support/shared_context/with_flow_callbacks"
require_relative "support/shared_context/with_operation_callbacks"
require_relative "support/shared_context/with_operations_for_a_flow"

require_relative "support/shared_examples/a_class_with_attributes_having_default_values"
require_relative "support/shared_examples/a_class_which_defines_into_a_class_collection"
require_relative "support/shared_examples/a_transaction_wrapper"
require_relative "support/shared_examples/method_is_wrapped_in_a_transaction"
require_relative "support/shared_examples/operation_double_runs_are_prevented"

SimpleCov.start do
  add_filter "/spec/"
end

require "flow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
