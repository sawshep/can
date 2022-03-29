module ArgParse

  USAGE = 'Usage: can [OPTION] [FILE]...'

  MODES = {
    :list     => ['-l', '--list', 'list files in the trash'],
    :info     => ['-i', '--info', 'see information about a trashed file'],
    :recover  => ['-r', '--recover', 'restore a trashed file'],
    :empty    => ['-e', '--empty', 'permanently remove a file from the trash; use with no arguments to empty entire trashcan'],
    :trash    => ['', '', 'trash a file']
  }

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

  # Returns the arguments to the program without any mode
  # flags, if there were any in the first place
  def ArgParse.get_args
    if valid_opt? ARGV[0]
      ARGV[1..]
    else
      ARGV
    end
  end

  # Return the mode indicated by the flag
  def ArgParse.get_mode
    ArgParse.valid_opt? ARGV[0] or :trash
  end
end
