PROJECT_ROOT_PATH = File.dirname(File.dirname(__FILE__))

require 'rubygems'
require 'rspec/collection_matchers'
require 'rspec/its'
require 'rspec/mocks'
require 'simplecov'

SimpleCov.start do
  root PROJECT_ROOT_PATH
  add_filter '/spec/'
  add_filter '/vendor/'
end

Dir[File.join(PROJECT_ROOT_PATH, 'lib', '**', '*.rb')].each do |f|
  require f
end
