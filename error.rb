EXIT_SUCCESS = 0
EXIT_FAILURE = 1

$exit = EXIT_SUCCESS

at_exit do
  exit $exit
end

module Error
  def Error.nonfatal (message)
    STDERR.puts('can: ' + message)
    $exit = EXIT_FAILURE
  end

  # Exits without callbacks to at_exit
  def Error.fatal (message)
    STDERR.puts('can: ' + message)
    exit!(EXIT_FAILURE)
  end
end
