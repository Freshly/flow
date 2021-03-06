# frozen_string_literal: true

module Flow
  module Generators
    class ApplicationFlowGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_flow
        template "application_flow.rb", File.join("app/flows/application_flow.rb")
      end
    end
  end
end
