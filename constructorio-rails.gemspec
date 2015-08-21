# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'constructorio-rails/version'

Gem::Specification.new do |spec|
  spec.name          = "constructorio-rails"
  spec.version       = ConstructorIORails::VERSION
  spec.authors       = ["Steven Lai"]
  spec.email         = ["lai.steven@gmail.com"]
  spec.summary       = %q{Rails gem for Constructor.io}
  spec.description   = %q{Rails gem for Constructor.io's autocomplete service. Enables Rails models to send updates to the Constructor.io API automatically, and provides a view helper to add autocomplete on any input.}
  spec.homepage      = "http://constructor.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency 'faraday', '~> 0.9', '>= 0.9.0'
  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10.1'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.10'
  spec.add_development_dependency 'mocha', '~> 1.1', '>= 1.1.0'
  spec.add_development_dependency "minitest", "~> 5.5.1"
end
