# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'griddler/postmark/version'

Gem::Specification.new do |spec|
  spec.name          = "griddler-postmark"
  spec.version       = Griddler::Postmark::VERSION
  spec.authors       = ['Randy Schmidt']
  spec.email         = ['me@r38y.com']
  spec.summary       = %q{Postmark adapter for Griddler}
  spec.description   = %q{Adapter to allow the use of Postmark Parse API with Griddler}
  spec.homepage      = "https://github.com/r38y/griddler-postmark"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

  spec.add_dependency "griddler"
end
