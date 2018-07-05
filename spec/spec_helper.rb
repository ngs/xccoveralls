PROJECT_ROOT_PATH = File.dirname(File.dirname(__FILE__))

require 'rubygems'
require 'rspec/collection_matchers'
require 'rspec/its'
require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [Coveralls::SimpleCov::Formatter, SimpleCov::Formatter::HTMLFormatter]
)

SimpleCov.start do
  root PROJECT_ROOT_PATH
  add_filter '/spec/'
end

ENV['COVERALLS_REPO_TOKEN'] && Coveralls.wear!

Dir[File.join(PROJECT_ROOT_PATH, 'lib', '**', '*.rb')].each do |f|
  require f
end
