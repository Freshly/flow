require "bundler/setup"
require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/rspec/"
end

require "spicery/spec_helper"
require "shoulda-matchers"

require "active_record"

require_relative "../lib/flow/spec_helper"

require "flow"

require_relative "support/shared_context/with_a_bottles_active_record"
require_relative "support/shared_context/with_a_users_active_record"
require_relative "support/shared_context/with_an_example_state"
require_relative "support/shared_context/with_an_example_operation"
require_relative "support/shared_context/with_example_flow_having_state"
require_relative "support/shared_context/with_flow_callbacks"
require_relative "support/shared_context/with_operation_callbacks"
require_relative "support/shared_context/with_operations_for_a_flow"

require_relative "support/shared_examples/a_transaction_wrapper"
require_relative "support/shared_examples/credentials_are_validated"
require_relative "support/shared_examples/method_is_wrapped_in_a_transaction"
require_relative "support/shared_examples/operation_double_runs_are_prevented"

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
    with.library :active_record
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
