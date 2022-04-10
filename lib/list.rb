module Can
  def self.list
    # Given no args, show every trashed file
    if ARGV.length == 0
      puts Dir.children(HOME_TRASH_FILES_DIRECTORY)

    # Given a regex pattern as an arg, print trashed files
    # that fit
    elsif ARGV.length == 1
      regex = Regexp.new(ARGV[0])
      puts Dir.children(HOME_TRASH_FILES_DIRECTORY).select { |file|
        regex =~ file
      }

    else
      raise StandardError.new(
        "can: mode --list expects 0 to 1 arguments, given #{ARGV.length}"
      )
    end
  end
end
