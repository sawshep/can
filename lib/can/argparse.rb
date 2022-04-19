# frozen_string_literal: true

require 'optparse'
require 'set'
require 'can/version'

# This needs to be here because OptParse only looks
# at `Version` and @version for the version number,
# not VERSION. Putting it in the namespace of `Can` or
# `ArgParse` breaks it. Annoying.
Version = Can::VERSION

module Can
  USAGE = 'Usage: can [OPTION] [FILE]...'

  MODES = {
    list: ['-l', '--list',
           'list files in the trash'],
    info: ['-n', '--info',
           'see information about a trashed file'],
    untrash: ['-u', '--untrash',
              'restore a trashed file'],
    empty: ['-e', '--empty',
            'permanently remove a file from the trash;
                  use with no arguments to empty entire
                  trashcan']
  }.freeze

  OPTIONS = {
    force: ['-f', '--force',
            'ignore nonexistent files and arguments,
                never prompt'],
    prompt: ['-i', nil, 'prompt before every trashing'],
    recursive: ['-r', '--recursive',
                'trash directories and their contents
                   recursively']
  }.freeze

  ALL_FLAGS = MODES.merge(OPTIONS).freeze

  module ArgParse
    Version = VERSION
    def self.init_args
      options = Set.new

      OptionParser.new do |opts|
        opts.banner = USAGE

        ALL_FLAGS.each do |mode, _v|
          opts.on(short_opt(mode), long_opt(mode), help_string(mode)) do |_opt|
            options << mode
          end
        end
      end.parse!

      Error.fatal 'Too many mode arguments' if ArgParse.incompatible_opts?(options)

      options
    end

    # Sees if options has incompatible items
    def self.incompatible_opts?(options)
      modes = MODES.keys
      (options & modes).length > 1
    end

    def self.mode(options)
      (options & MODES.keys).first || :trash
    end

    def self.short_opt(mode)
      ALL_FLAGS[mode][0]
    end

    def self.long_opt(mode)
      ALL_FLAGS[mode][1]
    end

    # Returns a mode's help string
    def self.help_string(mode)
      ALL_FLAGS[mode][2]
    end

    # Returns an options's corresponding mode, if it is valid
    def self.valid_opt?(opt)
      result = MODES.find do |_k, v|
        v[0..2].include? opt
      end
      result&.first
    end
  end
end
