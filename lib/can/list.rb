# frozen_string_literal: true

module Can
  def self.list
    # Given no args, show every trashed file
    if @argv.empty?
      puts Dir.children(HOME_TRASH_FILES_DIRECTORY)

    # Given a regex pattern as an arg, print trashed files
    # that fit
    elsif @argv.length == 1
      regex = Regexp.new(@argv[0])
      puts(
        Dir.children(HOME_TRASH_FILES_DIRECTORY).select do |file|
          regex =~ file
        end
      )

    else
      raise StandardError, "can: mode --list expects 0 to 1 arguments, given #{@argv.length}"
    end
  end
end
