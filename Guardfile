guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/(.*)_spec.rb$})
  watch(%r{^lib/(.*).rb$}) do |m|
    [
      "spec/#{m[1]}_spec.rb",
      'spec/xccoveralls_spec.rb'
    ]
  end
end

guard :rubocop do
  watch %r{^spec/(.*)_spec.rb$x/}
  watch %r{^lib/(.*).rb$}
end
