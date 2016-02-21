# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongo_mapper/exts/version'

Gem::Specification.new do |spec|
  spec.name          = "mongo_mapper-exts"
  spec.version       = MongoMapper::Exts::VERSION
  spec.authors       = ['Luis Correa d\'Almeida']
  spec.email         = ['luis@fullfabric.com']
  spec.summary       = 'mongo_mapper-exts'
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  # spec.homepage      = ""
  # spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mongo_mapper', '0.13.1'
  spec.add_dependency 'contracts'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'factory_girl', '~> 4.2.0'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'binding_of_caller'
  spec.add_development_dependency 'pry-byebug'

end
