require_relative 'lib/can/version'

Gem::Specification.new do |s|
  s.name        = 'can'
  s.version     = Can::VERSION
  s.summary     = 'Command-line trash manager'
  s.description = 'A command-line trashcan interface implementing the FreeDesktop trash specification as a drop-in replacement for rm.'
  s.authors     = ['Sawyer Shepherd']
  s.email       = 'contact@sawyershepherd.org'
  s.files       = ['lib/can/argparse.rb', 'lib/can/version.rb', 'lib/empty.rb', 'lib/error.rb', 'lib/info.rb', 'lib/list.rb', 'lib/trash.rb', 'lib/trashinfo.rb', 'lib/untrash.rb']
  s.homepage    = 'https://github.com/sawshep/can'
  s.license     = 'GPL-3.0'
end
