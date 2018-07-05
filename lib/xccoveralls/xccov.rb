require 'fastlane_core'
require 'buff/ignore'

module Xccoveralls
  class Xccov
    attr_reader :source_path
    attr_reader :derived_data_path

    def initialize(derived_data_path: nil, source_path: nil)
      @source_path = source_path
      @derived_data_path = derived_data_path
    end

    def test_logs_path
      File.join derived_data_path, 'Logs', 'Test'
    end

    def archive_path
      return @archive_path if @archive_path
      ext = '.xccovarchive'
      files = Dir[File.join(test_logs_path, "*#{ext}")]
      @archive_path = files.sort_by { |filename| File.mtime(filename) }
                           .reverse.first
      @archive_path ||
        user_error!("Could not find any #{ext} in #{derived_data_path}")
      @archive_path
    end

    def coverage(path)
      files.include?(path) ||
        user_error!("No coverage data for #{path}")
      res = exec(['--file', path])
      res.split("\n").map do |line|
        line = line.strip.split(/[\s:]/).reject(&:empty?)
        next unless line[0] =~ /^\d+$/
        hits = line[1]
        hits == '*' ? nil : hits.to_i
      end
    end

    def files
      @files ||= exec(%w[--file-list]).split("\n")
    end

    def exec(args)
      cmd = %w[xcrun xccov view] + args + [archive_path]
      FastlaneCore::CommandExecutor.execute(command: cmd.join(' ')).strip
    end

    private_class_method

    def user_error!(msg)
      FastlaneCore::UI.user_error!(msg)
    end
  end
end
