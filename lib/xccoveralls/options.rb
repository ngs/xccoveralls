require 'fastlane_core'

module Xccoveralls
  class Options
    def self.available_options # rubocop:disable Metrics/MethodLength, Metrics/LineLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
      root_path = `git rev-parse --show-toplevel`.strip
      [
        FastlaneCore::ConfigItem.new(
          key: :source_path,
          short_option: '-s',
          optional: true,
          env_name: 'XCCOVERALLS_SOURCE_PATH',
          description: 'Path to project root',
          default_value: root_path,
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            File.exist?(v) ||
              user_error!("Source path #{v} does not exist")
            File.directory?(v) ||
              user_error!("Source path #{v} is not a directory")
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :derived_data_path,
          short_option: '-d',
          optional: true,
          env_name: 'XCCOVERALLS_DERIVED_DATA_PATH',
          description: 'Path to DerivedData',
          default_value: "#{ENV.fetch('HOME')}/Library/Developer/Xcode/DerivedData", # rubocop:disable Metrics/LineLength
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            File.exist?(v) ||
              user_error!("Source path #{v} does not exist")
            File.directory?(v) ||
              user_error!("Source path #{v} is not a directory")
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :ignorefile_path,
          short_option: '-i',
          optional: true,
          env_name: 'XCCOVERALLS_IGNOREFILE_PATH',
          description: 'Path to Ignorefile',
          default_value: "#{root_path}/.coverallsignore",
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            File.exist?(v) ||
              user_error!("Ignorefile does not exist at #{v}")
            File.file?(v) ||
              user_error!("#{v} is not a file")
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :repo_token,
          short_option: '-t',
          optional: true,
          env_name: 'XCCOVERALLS_REPO_TOKEN',
          description: 'Coveralls secret repo token'
        )
      ]
    end

    private_class_method

    def self.user_error!(msg)
      FastlaneCore::UI.user_error!(msg)
    end
  end
end
