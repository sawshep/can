#!/usr/bin/env ruby

require 'cgi'
require 'date'
require 'fileutils'

require_relative './argparse.rb'
require_relative './empty.rb'
require_relative './info.rb'
require_relative './list.rb'
require_relative './untrash.rb'
require_relative './trash.rb'
require_relative './error.rb'

XDG_DATA_HOME_DEFAULT = File.join(ENV['HOME'], '.local/share')
XDG_DATA_HOME = ENV['XDG_DATA_HOME'] || XDG_DATA_HOME_DEFAULT

HOME_TRASH_DIRECTORY = File.join(XDG_DATA_HOME, 'Trash')
HOME_TRASH_INFO_DIRECTORY = File.join(HOME_TRASH_DIRECTORY, 'info')
HOME_TRASH_FILES_DIRECTORY = File.join(HOME_TRASH_DIRECTORY, 'files')

def init_dirs()
  FileUtils.mkpath HOME_TRASH_FILES_DIRECTORY
  FileUtils.mkpath HOME_TRASH_INFO_DIRECTORY
end

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

$exit = 0

ArgParse.init_args

mode = ArgParse.get_mode

init_dirs

send mode

exit $exit
