require 'pathname'

##
# Ignore things
# Originally bollowed from https://git.io/fbj4N
##
module Xccoveralls
  class Ignorefile
    attr_reader :statements
    COMMENT_OR_WHITESPACE = /^\s*(?:#.*)?$/

    def initialize(*args)
      @statements = []

      args.each do |arg|
        !arg.is_a?(Array) && File.exist?(arg) &&
          (return load_file(arg))
        push(arg)
      end
    end

    def push(*arg)
      statements.push(*arg.flatten.map(&:strip))

      self
    end
    alias << push

    def load_file(file)
      file = Pathname.new(file)
      return unless file.exist?

      push(file.readlines.map(&:strip).reject do |line|
        line.empty? || line =~ COMMENT_OR_WHITESPACE
      end)

      self
    end

    def ignored?(file) # rubocop:disable Metrics/AbcSize
      return true if file.to_s.strip.empty?

      path = Pathname.new file

      includes = statements.reject { |statement| statement[0] == '!' }
                           .map { |statement| "*#{statement}*" }

      excludes = statements.select { |statement| statement[0] == '!' }
                           .map { |statement| "*#{statement[1..-1]}*" }

      includes.any? { |statement| path.fnmatch?(statement) } &&
        excludes.all? { |statement| !path.fnmatch?(statement) }
    end

    def apply(files)
      files.reject { |file| ignored?(file) }
    end

    def apply!(files)
      files.reject! { |file| ignored?(file) }
    end
  end
end
