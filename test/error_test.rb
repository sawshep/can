# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/error'

class ErrorTest < Minitest::Test
  # Can't test fatal errors...
  def test_nonfatal
    assert_equal $exit, EXIT_SUCCESS

    assert_output('', /can: test\n/) { Error.nonfatal("test") }
    assert_equal $exit, EXIT_FAILURE

    # So the test does not fail
    $exit = EXIT_SUCCESS
  end
end
