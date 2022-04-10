module Can
  def self.untrash
    ARGV.each do |filename|
      file_path = File.join(HOME_TRASH_FILES_DIRECTORY, filename)

      if not File.exist? file_path
          if not $options.include? :force
            Error.nonfatal "cannot untrash '#{filename}': No such file or directory in trash"
          end
        next
      end

      trashinfo_filename = filename + '.trashinfo'
      trashinfo_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)
      trashinfo = Trashinfo.parse(File.read trashinfo_path)

      original_path = trashinfo[:path]

      # TODO: Implement more thorough error handling
      if File.exist? original_path
        Error.nonfatal "cannot untrash '#{filename}' to '#{original_path}': File exists"
        next
      end

      # TODO: Make sure ctime, atime, mtime, do not change
      FileUtils.mv file_path, original_path
      FileUtils.rm trashinfo_path
    end
  end
end
