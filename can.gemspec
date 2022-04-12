require_relative 'lib/can/version'

Gem::Specification.new do |s|
  s.name        = 'can_cli'
  s.version     = Can::VERSION
  s.executables << 'can'
  s.summary     = 'Command-line trash manager'
  s.description = 'A command-line trashcan interface implementing the FreeDesktop trash specification as a drop-in replacement for rm.'
  s.authors     = ['Sawyer Shepherd']
  s.email       = 'contact@sawyershepherd.org'
  s.files       = [
    'LICENSE',
    'README.md',
    'bin/can',
    'can.gemspec',
    'lib/can/argparse.rb',
    'lib/can/version.rb',
    'lib/can.rb',
    'lib/empty.rb',
    'lib/error.rb',
    'lib/info.rb',
    'lib/list.rb',
    'lib/trash.rb',
    'lib/trashinfo.rb',
    'lib/untrash.rb'
  ]
  s.homepage    = 'https://github.com/sawshep/can'
  s.license     = 'GPL-3.0'
  s.add_runtime_dependency 'highline', '~> 2.0'
end
