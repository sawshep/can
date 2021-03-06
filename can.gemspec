# frozen_string_literal: true

require_relative 'lib/can/version'

Gem::Specification.new do |s|
  s.name        = 'can_cli'
  s.version     = Can::VERSION
  s.executables << 'can'
  s.summary     = 'Command-line trash manager'
  s.description = 'A command-line trashcan interface implementing the FreeDesktop trash specification as a drop-in replacement for rm.'
  s.authors     = ['Sawyer Shepherd']
  s.email       = 'contact@sawyershepherd.org'
  s.files       = %w[
    LICENSE
    README.md
    bin/can
    can.gemspec
    lib/can.rb
    lib/can/argparse.rb
    lib/can/empty.rb
    lib/can/info.rb
    lib/can/list.rb
    lib/can/trash.rb
    lib/can/untrash.rb
    lib/can/version.rb
    lib/error.rb
    lib/trashinfo.rb
  ]
  s.homepage    = 'https://github.com/sawshep/can'
  s.license     = 'GPL-3.0'
  s.required_ruby_version = '>= 3.0'
  s.add_runtime_dependency 'highline', '~> 2.0'
end
