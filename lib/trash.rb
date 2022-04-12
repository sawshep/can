require 'highline'

# Returns filename with all trailing extensions removed
def strip_extensions(filename)
  ext = File.extname filename
  if ext.empty?
    return filename
  end
  strip_extensions(File.basename(filename, ext))
end

# Returns all extensions of a filename
def gather_extensions(filename)
  exts = ''
  while not File.extname(filename).empty?
    ext = File.extname(filename)
    exts = ext + exts
    filename = File.basename(filename, ext)
  end
  exts
end

module Can
  def self.trash
    if ARGV.length == 0 and not $options.include? :force
        Error.fatal 'missing operand'
    end

    ARGV.each do |path|

      # TODO: If both `-f` and `-i` are used, can should
      # prompt if `-i` is used last. If `-f` is used last,
      # can should not prompt trashings. This follows the
      # behavior of rm.
      if not File.exist?(path)
        if not $options.include? :force
          Error.nonfatal "cannot trash '#{path}': No such file or directory"
        end
        next
      end

      # If --recursive is not used and a directory is given as an
      # argument, a non-zero error code should be returned
      # regardless if --force is used.
      if File.directory? path and not File.symlink? path
        if not $options.include? :recursive
          Error.nonfatal "cannot remove '#{path}': Is a directory"
        end
        next
      end

      # TODO: Highline.agree prints to stdout, when it should
      # print to stderr. It also uses `puts`, while this use
      # case should use `print`.
      if $options.include? :prompt
        unless HighLine.agree "can: remove file '#{path}'?"
          next
        end
      end

      filename = File.basename path

      trashinfo_string = Trashinfo.new path

      existing_trash_files = Dir.children HOME_TRASH_FILES_DIRECTORY

      # The File.basename function only strips the last
      # extension. These functions are needed to support files
      # with multiple extensions, like file.txt.bkp
      basename = strip_extensions(filename)
      exts = gather_extensions(filename)

      # Most implementations add a number as the first
      # extension to prevent file conflicts
      i = 0
      while existing_trash_files.include?(filename)
        i += 1
        filename = basename + ".#{i}" + exts
      end

      FileUtils.mv(path, File.join(HOME_TRASH_FILES_DIRECTORY, filename))

      trashinfo_filename = filename + '.trashinfo'
      trashinfo_out_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)
      File.new(trashinfo_out_path, 'w').syswrite(trashinfo_string)
    end
  end
end