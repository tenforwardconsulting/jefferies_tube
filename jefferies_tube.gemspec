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

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 3.0'

  spec.add_dependency "bundler-audit", '~> 0.6.1'
end
