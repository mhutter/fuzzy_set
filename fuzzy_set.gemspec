# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuzzy_set/version'

Gem::Specification.new do |spec|
  spec.name          = 'fuzzy_set'
  spec.version       = FuzzySet::VERSION
  spec.authors       = ['Manuel Hutter']
  spec.email         = ['manuel@hutter.io']

  spec.summary       = %q{Set which allows you to fuzzy-search Strings}
  spec.description   = %q{FuzzySet represents a set which allows searching its entries by using [Approximate string matching](https://en.wikipedia.org/wiki/Approximate_string_matching).}
  spec.homepage      = 'https://github.com/mhutter/fuzzy_set'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'string-similarity', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
