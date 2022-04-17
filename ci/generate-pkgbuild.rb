#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

ci_dir = File.expand_path(File.dirname(__FILE__))
repo_root = File.expand_path(File.join(ci_dir, '..'))

require_relative File.join(repo_root, 'lib/can/version')

# Get the sha256sum from RubyGems
gems_api_uri = URI.parse("https://rubygems.org/api/v1/gems/can_cli.json")
gems_api_response = Net::HTTP.get_response(gems_api_uri)
sha256sum = JSON.parse(gems_api_response.body)["sha"]

# Get the old PKGBUILD from the AUR to find the old $pkgrel
old_pkgbuild_uri = URI.parse("https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=can")
pkgbuild_response = Net::HTTP.get_response(old_pkgbuild_uri)
pkgrel_regex = /^pkgrel=([0-9]+?)$/
old_pkgrel = pkgrel_regex.match(pkgbuild_response.body)[1]
new_pkgrel = old_pkgrel.to_i + 1

pkgbuild = <<~PKGBUILD
  # Maintainer: Sawyer Shepherd <contact@sawyershepherd.org>

  _gemname=can_cli
  pkgname=can
  pkgver=#{Can::VERSION}
  pkgrel=#{new_pkgrel}
  pkgdesc='Command-line trash manager'
  arch=(any)
  url='https://github.com/sawshep/can'
  license=(GPL-3.0)
  depends=(ruby ruby-highline)
  options=(!emptydirs)
  source=(https://rubygems.org/downloads/$_gemname-$pkgver.gem)
  noextract=($_gemname-$pkgver.gem)
  sha256sums=('#{sha256sum}')

  package() {
    local _gemdir="$(ruby -e'puts Gem.default_dir')"
    gem install --ignore-dependencies --no-user-install -i "$pkgdir/$_gemdir" -n "$pkgdir/usr/bin" $_gemname-$pkgver.gem
    rm "$pkgdir/$_gemdir/cache/$_gemname-$pkgver.gem"
    install -D -m644 "$pkgdir/$_gemdir/gems/$_gemname-$pkgver/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
  }
PKGBUILD

pkgbuild_path = File.join(repo_root, 'PKGBUILD')
File.open(pkgbuild_path, 'w') { |file| file.write(pkgbuild) }
