# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'only_once/version'

Gem::Specification.new do |spec|
  spec.name          = "only_once"
  spec.version       = OnlyOnce::VERSION
  spec.authors       = ["Neil Berget"]
  spec.email         = ["neil.berget@gmail.com"]
  spec.description   = "Run a block of code only once"
  spec.summary       = "Uses Redis to run a block of code only once"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
