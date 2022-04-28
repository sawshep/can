# frozen_string_literal: true

require 'fileutils'

require 'trashinfo'
require 'error'

require 'can/argparse'
require 'can/empty'
require 'can/info'
require 'can/list'
require 'can/untrash'
require 'can/trash'

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
    @options = ArgParse.init_args

    mode = ArgParse.mode @options

    init_dirs

    send mode

    $exit = EXIT_SUCCESS if @options.include?(:force)
  end
end
