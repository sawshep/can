# frozen_string_literal: true

module Can
  def self.list
    # Given no args, show every trashed file
    if ARGV.empty?
      puts Dir.children(HOME_TRASH_FILES_DIRECTORY)

    # Given a regex pattern as an arg, print trashed files
    # that fit
    elsif ARGV.length == 1
      regex = Regexp.new(ARGV[0])
      puts(
        Dir.children(HOME_TRASH_FILES_DIRECTORY).select do |file|
          regex =~ file
        end
      )

    else
      raise StandardError, "can: mode --list expects 0 to 1 arguments, given #{ARGV.length}"
    end
  end
end
