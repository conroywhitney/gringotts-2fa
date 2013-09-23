# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gringotts/version'

Gem::Specification.new do |spec|
  spec.name          = "gringotts"
  spec.version       = Gringotts::VERSION
  spec.authors       = ["Conroy Whitney"]
  spec.email         = ["conroy.whitney@gmail.com"]
  spec.description   = %q{Easy-peasy 2-Factor Authentication}
  spec.summary       = %q{Integrates with a secure server running Gringotts 2FA}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
end
