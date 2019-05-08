
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flow/version"

Gem::Specification.new do |spec|
  spec.name          = "flow"
  spec.version       = Flow::VERSION
  spec.authors       = ["Eric Garside", "Allen Rettberg", "Jordan Minneti", "Vinod Lala"]
  spec.email         = ["eric.garside@freshly.com"]

  spec.summary       = "Write modular and reusable business logic that's understandable and maintainable."
  spec.description   = "Tired of kitchen sink services, god-objects, and fat-everything? So were we. Get in the flow."
  spec.homepage      = "http://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activemodel", "~> 5.2.1"
  spec.add_runtime_dependency "activerecord", "~> 5.2.1"
  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "spicerack", "~> 0.7.1"

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "rubocop", "~> 0.58"
  spec.add_development_dependency "rubocop-rspec", "~> 1.27"
  spec.add_development_dependency "faker", "~> 1.8"
  spec.add_development_dependency "pry-byebug", ">= 3.7.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.6"

  spec.add_development_dependency "rspice", "~> 0.7.1"
  spec.add_development_dependency "spicerack-styleguide", "~> 0.7.1"
  spec.add_development_dependency "shoulda-matchers", "4.0.1"
end
