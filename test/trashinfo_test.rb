# frozen_string_literal: true

require './lib/trashinfo'
require 'fileutils'
require 'minitest/autorun'
require 'minitest/pride'

class TrashinfoTest < Minitest::Test
  def test
    path = '/does/not/exist'
    date = Time.now.strftime('%Y-%m-%dT%H:%M:%S')
    trashinfo = Trashinfo.new path

    parsed = Trashinfo.parse trashinfo
    assert_equal path, parsed[:path]
    assert_equal date, parsed[:deletion_date]
  end
end
