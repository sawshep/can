# frozen_string_literal: true

TMP_DIR = File.join(Dir.pwd, 'tmp')
# Puts the trash files in a tmp dir
ENV['XDG_DATA_HOME'] = TMP_DIR

require './lib/can'
require './lib/can/argparse'
require './lib/can/empty'
require './lib/can/info'
require './lib/can/list'
require './lib/can/trash'
require './lib/can/untrash'
require './lib/can/version'

require 'fileutils'
require 'minitest/autorun'
require 'minitest/pride'
require 'securerandom'
require 'set'

class CanTest < Minitest::Test
  def make_test_file
    name = SecureRandom.hex
    path = File.join(TMP_DIR, name)

    FileUtils.mkpath TMP_DIR
    FileUtils.touch path

    return name, path
  end

  def test_init_dirs
    Can::init_dirs
    assert File.directory?(Can::HOME_TRASH_INFO_DIRECTORY)
    assert File.directory?(Can::HOME_TRASH_FILES_DIRECTORY)
  end

  def test_argparse
    argv = %w[-f foo -i bar --recursive]
    opts, args = Can::ArgParse.init_args(argv)

    assert_equal args, %w[foo bar]
    %i[force prompt recursive].each { |x| assert_includes opts, x }
    assert_equal Can::ArgParse.mode(opts), :trash
  end

  def test_empty
    filename, path = make_test_file

    Can.can [path]
    Can.can ['-e', filename]

    trash_file_path = File.join(Can::HOME_TRASH_FILES_DIRECTORY, filename)
    trashinfo_file_path = File.join(Can::HOME_TRASH_INFO_DIRECTORY, filename + '.trashinfo')

    refute_path_exists trash_file_path
    refute_path_exists trashinfo_file_path
  end

  def test_info
    filename, path = make_test_file

    regex = /
      #{filename}:\n
      Path:\p{Space}#{path}\n
      Deletion\p{Space}Date:\p{Space}[0-9]{4}(-[0-9]{2}){2}T[0-9]{2}(:[0-9]{2}){2}\n
    /x

    Can.can [path]

    assert_output(regex) { Can.can ['-n', filename] }
  end

  def test_list
    filename, path = make_test_file

    Can.can [path]

    assert_output(/^#{filename}$/) { Can.can ['-l'] }
  end

  def test_trash
    filename, path = make_test_file

    Can.can [path]

    trash_file_path = File.join(Can::HOME_TRASH_FILES_DIRECTORY, filename)
    trashinfo_file_path = File.join(Can::HOME_TRASH_INFO_DIRECTORY, filename + '.trashinfo')

    assert_path_exists trash_file_path
    assert_path_exists trashinfo_file_path
  end

  def test_untrash
    filename, path = make_test_file

    Can.can [path]
    Can.can ['-u', filename]

    assert_path_exists path
  end

  def test_version
    assert Can::VERSION
  end
end
