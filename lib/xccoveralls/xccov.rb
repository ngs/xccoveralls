require 'fastlane_core'
require 'xccoveralls/ignorefile'

module Xccoveralls
  class Xccov
    attr_reader :source_path
    attr_reader :derived_data_path
    attr_reader :ignorefile_path

    def initialize(
      derived_data_path: nil,
      source_path: nil,
      ignorefile_path: nil
    )
      @source_path = source_path
      @derived_data_path = derived_data_path
      @ignorefile_path = ignorefile_path || File.join(
        source_path, '.coverallsignore'
      )
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
      file_paths.include?(path) ||
        user_error!("No coverage data for #{path}")
      res = exec(['--file', "'#{path}'"])
      res.split("\n").map do |line|
        line = line.strip.split(/[\s:]/).reject(&:empty?)
        next unless line[0] =~ /^\d+$/
        hits = line[1]
        hits == '*' ? nil : hits.to_i
      end
    end

    def source_digest(path)
      File.file?(path) ||
        user_error!("File at #{path} does not exist")
      FastlaneCore::CommandExecutor.execute(
        command: %w[git hash-object] + %W["#{path}"],
        print_command: false
      ).strip
    end

    def name(path)
      path.start_with?(source_path) || (return path)
      Pathname.new(path).relative_path_from(
        Pathname.new(source_path)
      ).to_s
    end

    # http://docs.coveralls.io/api-introduction#source-files
    def file(path)
      {
        name: name(path),
        source_digest: source_digest(path),
        coverage: coverage(path)
      }
    end

    def files
      file_paths.map { |path| file(path) }
    end

    def to_json
      { source_files: files }
    end

    def file_paths
      return @file_paths if @file_paths
      paths = exec(%w[--file-list]).split("\n")
      if File.file?(ignorefile_path)
        ignore = Ignorefile.new(ignorefile_path)
        ignore.apply!(paths)
      end
      @file_paths = paths
    end

    def exec(args)
      cmd = %w[xcrun xccov view] + args + %W["#{archive_path}"]
      FastlaneCore::CommandExecutor.execute(
        command: cmd,
        print_command: false
      ).strip
    end

    private_class_method

    def user_error!(msg)
      FastlaneCore::UI.user_error!(msg)
    end
  end
end
