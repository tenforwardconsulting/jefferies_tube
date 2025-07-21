# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jefferies_tube/version'

Gem::Specification.new do |spec|
  spec.name          = "jefferies_tube"
  spec.version       = JefferiesTube::VERSION
  spec.authors       = ["Brian Samson"]
  spec.email         = ["brian@tenforwardconsulting.com"]
  spec.summary       = %q{Ten Forward Consulting useful tools.}
  spec.description   = "Useful tools for Rails."
  spec.homepage      = "https://github.com/tenforwardconsulting/jefferies_tube/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 3.2'

  spec.add_development_dependency "awesome_print", '~> 1.9.2'
  spec.add_development_dependency "bundler", '~> 2.3.7'
  spec.add_development_dependency "pry", '~> 0.13'
  spec.add_development_dependency "rake", '~> 13.0.6'
  spec.add_development_dependency "rspec", '~> 3.0'

  spec.add_dependency "bundler-audit", "~> 0.9"
  spec.add_dependency "pry", '~> 0.13'
  spec.add_dependency 'rubocop', '~> 1.26'
  spec.add_dependency 'rubocop-rails', '~> 2.14.2'
  spec.add_dependency 'simplecov', '~> 0.22.0'
end
