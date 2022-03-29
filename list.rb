def list
  # Given no args, show every trashed file
  if $args.length == 0
    puts Dir.children(HOME_TRASH_FILES_DIRECTORY)

  # Given a regex pattern as an arg, print trashed files
  # that fit
  elsif $args.length == 1
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
