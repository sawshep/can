# frozen_string_literal: true

module Can
  def self.info
    # Fails with a fatal error even with --force, intended
    # behavior.
    if ARGV.empty?
      Error.fatal 'missing operand'
    else
      ARGV.each_with_index do |file, i|
        trashinfo_filename = "#{file}.trashinfo"
        trashinfo_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)

        unless File.exist? trashinfo_path
          Error.nonfatal "no such file in trashcan: '#{file}'"
          next
        end

        trashinfo = Trashinfo.parse(File.read(trashinfo_path))

        # TODO: Checking if i is not zero every single
        # iteration is a little inefficient. Maybe there is a
        # better way to do this?
        puts if i != 0
        puts <<~INFO
          #{file}:
          Path: #{trashinfo[:path]}
          Deletion Date: #{trashinfo[:deletion_date]}
        INFO
      end
    end
  end
end
