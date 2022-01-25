#!/usr/bin/env ruby

require 'cgi'
require 'date'
require 'fileutils'

XDG_DATA_HOME_DEFAULT = File.join(ENV['HOME'], '.local/share')
XDG_DATA_HOME = ENV['XDG_DATA_HOME'] || XDG_DATA_HOME_DEFAULT

HOME_TRASH_DIRECTORY = File.join(XDG_DATA_HOME, 'Trash')
HOME_TRASH_INFO_DIRECTORY = File.join(HOME_TRASH_DIRECTORY, 'info')
HOME_TRASH_FILES_DIRECTORY = File.join(HOME_TRASH_DIRECTORY, 'files')

def init_dirs()
  FileUtils.mkpath HOME_TRASH_FILES_DIRECTORY
  FileUtils.mkpath HOME_TRASH_INFO_DIRECTORY
end

def strip_extensions(filename)
  ext = File.extname filename
  if ext.empty?
    return filename
  end
  strip_extensions(File.basename(filename, ext))
end

def gather_extensions(filename)
  exts = ''
  while not File.extname(filename).empty?
    ext = File.extname(filename)
    exts = ext + exts
    filename = File.basename(filename, ext)
  end
  exts
end
  
init_dirs

ARGV.each do |path|
  # only ctime should change
  #atime = File.atime path
  #mtime = File.mtime path
  #ctime = File.ctime path
  filename = File.basename path

  trashinfo_string = <<~DESKTOP
    [Trash Info]
    Path=#{CGI.escape(File.expand_path path)}
    DeletionDate=#{Date.new.strftime('%Y-%m-%dT%H:%M:%S')}
  DESKTOP

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

  begin
    File.exist?(path) || (raise StandardError.new "can: cannot trash '#{path}': No such file or directory")
  rescue => e
    puts e.message
    next
  end

  FileUtils.mv(path, File.join(HOME_TRASH_FILES_DIRECTORY, filename))

  trashinfo_filename = filename + '.trashinfo'
  trashinfo_out_path = File.join(HOME_TRASH_INFO_DIRECTORY, trashinfo_filename)
  File.new(trashinfo_out_path, 'w').syswrite(trashinfo_string)
end
