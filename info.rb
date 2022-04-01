def info
  if ARGV.length == 0
    Error.fatal USAGE
  else
    ARGV.map { |file|
      trashinfo_filename = file + '.trashinfo'
      trashinfo_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)
      puts File.read(trashinfo_path)
    }
  end
end
