require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'coveralls/rake/task'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

Coveralls::RakeTask.new

task default: %i[rubocop spec]
