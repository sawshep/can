# TODO: Parse the .trashinfo files to make them more human
# readable. Also, display the filename above the information
# with empty lines between consecutive info blocks.
def info
  # Fails with a fatal error even with --force, intended
  # behavior.
  if ARGV.length == 0
    Error.fatal 'missing operand'
  else
    ARGV.each_with_index { |file, i|
      trashinfo_filename = file + '.trashinfo'
      trashinfo_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)

      if not File.exist? trashinfo_path
        Error.nonfatal "no such file in trashcan: '#{file}'"
        next
      end

      trashinfo = Trashinfo.parse(File.read trashinfo_path)

      # TODO: Checking if i is not zero every single
      # iteration is a little inefficient. Maybe there is a
      # better way to do this?
      puts if i != 0
      puts <<~INFO
        #{file}:
        Path: #{trashinfo[:path]}
        Deletion Date: #{trashinfo[:deletion_date]}
      INFO
    }
  end
end
