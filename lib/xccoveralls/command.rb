require 'commander'
require 'fastlane_core'
require 'xccoveralls/options'
require 'xccoveralls/runner'
require 'xccoveralls/version'

HighLine.track_eof = false

module Xccoveralls
  class Command
    include Commander::Methods
    FastlaneCore::CommanderGenerator.new.generate(Options.available_options)

    def self.run!
      FastlaneCore::UpdateChecker.start_looking_for_update NAME
      new.run!
    ensure
      FastlaneCore::UpdateChecker.show_update_status NAME, VERSION
    end

    def initialize # rubocop:disable Metrics/MethodLength
      program :version, VERSION
      program :description, DESCRIPTION
      program :help, 'Author', 'Atsushi Nagase <a@ngs.io>'
      program :help, 'Blog', 'https://ngs.io'
      program :help, 'GitHub', 'https://github.com/ngs/xccoveralls'
      program :help_formatter, :compact

      global_option('--verbose') do
        FastlaneCore::Globals.verbose = true
        ENV['COVERALLS_DEBUG'] = '1'
      end

      command(:report) { |command| setup_report(command) }
      default_command :report
    end

    def setup_report(command)
      command.syntax = NAME
      command.description = 'Send Coverage information to Coveralls'
      command.action { |args, options| run_report!(args, options) }
      FastlaneCore::CommanderGenerator.new.generate(
        Options.available_options,
        command: command
      )
    end

    def run_report!(_args, options)
      config = FastlaneCore::Configuration.create(
        Options.available_options,
        options.__hash__.reject { |k, _v| k == :verbose }
      )
      Xccoveralls::Runner.new(config.values).run!
    end
  end
end
