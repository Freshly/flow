# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flow/version"

Gem::Specification.new do |spec|
  spec.name          = "flow"
  spec.version       = Flow::VERSION
  spec.authors       = [ "Eric Garside", "Allen Rettberg", "Jordan Minneti", "Vinod Lala", "Andrew Cross" ]
  spec.email         = %w[eric.garside@freshly.com]

  spec.summary       = "Write modular and reusable business logic that's understandable and maintainable."
  spec.description   = "Tired of kitchen sink services, god-objects, and fat-everything? So were we. Get in the flow."
  spec.homepage      = "https://github.com/Freshly/flow"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activemodel", ">= 5.2.1"
  spec.add_runtime_dependency "activesupport", ">= 5.2.1"

  # TODO: replace spicerack with substance in next minor version
  # spec.add_runtime_dependency "substance", ">= 0.2.0", "< 1.0"
  spec.add_runtime_dependency "spicerack", ">= 0.2.0", "< 1.0"

  spec.add_runtime_dependency "short_circu_it", ">= 0.2.0", "< 1.0"
  spec.add_runtime_dependency "technologic", ">= 0.2.0", "< 1.0"
  spec.add_runtime_dependency "malfunction", ">= 0.2.0", "< 1.0"

  spec.add_development_dependency "activerecord", ">= 5.2.1"
  spec.add_development_dependency "bundler", ">= 2.0.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "pry-byebug", ">= 3.7.0"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "bcrypt", "~> 3.1.13"
  spec.add_development_dependency "shoulda-matchers", "4.0.1"

  spec.add_development_dependency "rspice", ">= 0.25.7", "< 1.0"
  spec.add_development_dependency "spicerack-styleguide", ">= 0.21.0", "< 1.0"
end
