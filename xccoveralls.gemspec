lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xccoveralls/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = Xccoveralls::NAME
  spec.version       = Xccoveralls::VERSION
  spec.authors       = ['Atsushi Nagase']
  spec.email         = ['a@ngs.io']
  spec.summary       = Xccoveralls::DESCRIPTION
  spec.description   = Xccoveralls::DESCRIPTION
  spec.homepage      = 'https://github.com/ngs/xccoveralls'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.1.0'

  spec.files = Dir['lib/**/*'] + %w[bin/xcccoverallseralls README.md LICENSE]

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'coveralls', '>= 0.8'
  spec.add_dependency 'fastlane', '>= 2.82', '< 3.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-collection_matchers'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
