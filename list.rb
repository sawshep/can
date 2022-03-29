def list

  if $args.length == 0
    # Given no args, show every trashed file
    puts Dir.children(HOME_TRASH_FILES_DIRECTORY)

  elsif $args.length == 1
    # Given a regex pattern as an arg, print trashed files
    # that fit
    regex = Regexp.new($args[0])
    puts Dir.children(HOME_TRASH_FILES_DIRECTORY).select { |file|
      regex =~ file
    }

  else
    raise StandardError.new(
      "can: mode --list expects 0 to 1 arguments, given #{$args.length}"
    )
  end
end
