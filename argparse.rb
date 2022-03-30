require 'optparse'
require 'set'

$options = Set.new

module ArgParse
  USAGE = 'Usage: can [OPTION] [FILE]...'

  MODES = {
    :list     => ['-l', '--list', 'list files in the trash'],
    :info     => ['-i', '--info', 'see information about a trashed file'],
    :recover  => ['-r', '--recover', 'restore a trashed file'],
    :empty    => ['-e', '--empty', 'permanently remove a file from the trash; use with no arguments to empty entire trashcan'],
  }

  def ArgParse.init_args
    OptionParser.new do |opts|
      opts.banner = USAGE

      MODES.map do |mode,v|
        opts.on(short_opt(mode), long_opt(mode), help_string(mode)) do |opt|
          $options << mode
        end
      end
    end.parse!

    if ArgParse.incompatible_opts?
      raise StandardError.new "can: Too many mode arguments"
    end
  end

  # Sees if $options has incompatible items
  def ArgParse.incompatible_opts?
    modes = MODES.keys
    ($options & modes).length > 1
  end

  def ArgParse.get_mode
    ($options & MODES.keys).first || :trash
  end

  def ArgParse.short_opt (mode)
    MODES[mode][0]
  end

  def ArgParse.long_opt (mode)
    MODES[mode][1]
  end

  # Returns a mode's help string
  def ArgParse.help_string (mode)
    MODES[mode][2]
  end

  # Returns an options's corresponding mode, if it is valid
  def ArgParse.valid_opt? (opt)
    result = MODES.find { |k,v|
      v[0..2].include? opt
    }
    if result
      result.first
    end
  end
end
