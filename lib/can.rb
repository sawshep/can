# frozen_string_literal: true

require 'fileutils'

require 'can/argparse'
require 'trashinfo'
require 'error'

require_relative 'empty'
require_relative 'info'
require_relative 'list'
require_relative 'untrash'
require_relative 'trash'

module Can
  XDG_DATA_HOME_DEFAULT = File.join(ENV['HOME'], '.local/share')
  XDG_DATA_HOME = ENV['XDG_DATA_HOME'] || XDG_DATA_HOME_DEFAULT

  HOME_TRASH_DIRECTORY = File.join(XDG_DATA_HOME, 'Trash')
  HOME_TRASH_INFO_DIRECTORY = File.join(HOME_TRASH_DIRECTORY, 'info')
  HOME_TRASH_FILES_DIRECTORY = File.join(HOME_TRASH_DIRECTORY, 'files')

  def self.init_dirs
    FileUtils.mkpath HOME_TRASH_FILES_DIRECTORY
    FileUtils.mkpath HOME_TRASH_INFO_DIRECTORY
  end

  def self.can
    ArgParse.init_args

    mode = ArgParse.mode

    init_dirs

    send mode

    $exit = EXIT_SUCCESS if $options.include? :force
  end
end
