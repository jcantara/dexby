# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dexby/version'

Gem::Specification.new do |spec|
  spec.name          = "dexby"
  spec.version       = Dexby::VERSION
  spec.authors       = ["Jesse Cantara"]
  spec.email         = ["jcantara@gmail.com"]
  spec.summary       = %q{Ruby API wrapper for Dexcom data}
  spec.homepage      = "https://github.com/jcantara/dexby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "httparty"
end
