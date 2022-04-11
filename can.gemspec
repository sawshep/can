require_relative 'lib/can/version'

Gem::Specification.new do |s|
  s.name        = 'can_cli'
  s.version     = Can::VERSION
  s.executables << 'can'
  s.summary     = 'Command-line trash manager'
  s.description = 'A command-line trashcan interface implementing the FreeDesktop trash specification as a drop-in replacement for rm.'
  s.authors     = ['Sawyer Shepherd']
  s.email       = 'contact@sawyershepherd.org'
  s.files       = `git ls-files -z`.split "\x0"
  s.homepage    = 'https://github.com/sawshep/can'
  s.license     = 'GPL-3.0'
end
