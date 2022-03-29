def empty
  # Remove everything in the files and info directory
  if $args.length == 0
    FileUtils.rm_r Dir.glob("#{HOME_TRASH_INFO_DIRECTORY}/*"), secure: true
    FileUtils.rm_r Dir.glob("#{HOME_TRASH_FILES_DIRECTORY}/*"), secure: true
  else
    $args.map { |filename|
      trashinfo_filename = filename + '.trashinfo'

      file_path = File.join(HOME_TRASH_FILES_DIRECTORY, filename)
      trashinfo_file_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)

      FileUtils.remove_entry_secure file_path
      FileUtils.remove_entry_secure trashinfo_file_path
    }
  end
end
