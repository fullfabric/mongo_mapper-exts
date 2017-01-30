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

  spec.add_dependency 'contracts'
  spec.add_dependency 'mongo_mapper'
  spec.add_dependency 'activesupport', '~> 3.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

 # lock listen to avoid issues with ruby_deps on 2.1.5
  spec.add_development_dependency 'listen', '3.0.8'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'binding_of_caller'
  spec.add_development_dependency 'pry-byebug'

end
