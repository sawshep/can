require 'optparse'
require 'set'

$options = Set.new

USAGE = 'Usage: can [OPTION] [FILE]...'

module ArgParse

  MODES = {
    :list     => ['-l', '--list',
                  'list files in the trash'],
    :info     => ['-n', '--info',
                  'see information about a trashed file'],
    :untrash  => ['-u', '--untrash',
                  'restore a trashed file'],
    :empty    => ['-e', '--empty',
                  'permanently remove a file from the trash;
                  use with no arguments to empty entire
                  trashcan'],
  }

  OPTIONS = {
    :force =>     ['-f', '--force',
                'ignore nonexistent files and arguments,
                never prompt'],
    :prompt =>    ['-i', nil, 'prompt before every trashing'],
    :recursive => ['-r', '--recursive',
                   'trash directories and their contents
                   recursively']
  }

  ALL_FLAGS = MODES.merge(OPTIONS)

  def self.init_args
    OptionParser.new do |opts|
      opts.banner = USAGE

      ALL_FLAGS.each do |mode,v|
        opts.on(short_opt(mode), long_opt(mode), help_string(mode)) do |opt|
          $options << mode
        end
      end
    end.parse!

    if ArgParse.incompatible_opts?
      Error.fatal "Too many mode arguments"
    end
  end

  # Sees if $options has incompatible items
  def self.incompatible_opts?
    modes = MODES.keys
    ($options & modes).length > 1
  end

  def self.get_mode
    ($options & MODES.keys).first || :trash
  end

  def self.short_opt (mode)
    ALL_FLAGS[mode][0]
  end

  def self.long_opt (mode)
    ALL_FLAGS[mode][1]
  end

  # Returns a mode's help string
  def self.help_string (mode)
    ALL_FLAGS[mode][2]
  end

  # Returns an options's corresponding mode, if it is valid
  def self.valid_opt? (opt)
    result = MODES.find { |k,v|
      v[0..2].include? opt
    }
    if result
      result.first
    end
  end
end
