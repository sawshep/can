def empty
  if $args.length == 0
    FileUtils.rm_r Dir.glob("#{HOME_TRASH_INFO_DIRECTORY}/*"), secure: true
    FileUtils.rm_r Dir.glob("#{HOME_TRASH_FILES_DIRECTORY}/*"), secure: true
  end
end
