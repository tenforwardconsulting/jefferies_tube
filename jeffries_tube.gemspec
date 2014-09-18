# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jeffries_tube/version'

Gem::Specification.new do |spec|
  spec.name          = "jeffries_tube"
  spec.version       = JeffriesTube::VERSION
  spec.authors       = ["Brian Samson"]
  spec.email         = ["brian@tenforwardconsulting.com"]
  spec.summary       = %q{Ten Forward Consulting useful tools.}
  spec.description   = %q{cap rails:console}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
