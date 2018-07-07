require 'fastlane_core'
require 'xccoveralls/xccov'
require 'coveralls/api'

module Xccoveralls
  class Manager
    attr_reader :repo_token
    attr_reader :xccov
    attr_reader :coveralls_configuration

    def initialize(
      repo_token: nil, derived_data_path: nil,
      source_path: nil, ignorefile_path: nil
    )
      options = {
        derived_data_path: derived_data_path,
        source_path: source_path, ignorefile_path: ignorefile_path
      }
      @xccov = Xccoveralls::Xccov.new(options)
      @repo_token = repo_token

      FastlaneCore::PrintTable.print_values(
        config: options,
        title: "Summary for #{Xccoveralls::NAME} #{Xccoveralls::VERSION}"
      )
    end

    def run!
      org_repo_token = ENV['COVERALLS_REPO_TOKEN']
      ENV['COVERALLS_REPO_TOKEN'] = repo_token || org_repo_token
      @coveralls_configuration = Coveralls::Configuration.configuration
      Coveralls::API.post_json 'jobs', xccov.json
      ENV['COVERALLS_REPO_TOKEN'] = org_repo_token
    end
  end
end
