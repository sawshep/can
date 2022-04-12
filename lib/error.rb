# frozen_string_literal: true

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

$exit = EXIT_SUCCESS

at_exit do
  exit $exit
end

module Error
  def self.nonfatal(message)
    warn "can: #{message}"
    $exit = EXIT_FAILURE
  end

  # Exits without callbacks to at_exit
  def self.fatal(message)
    warn "can: #{message}"
    exit!(EXIT_FAILURE)
  end
end
