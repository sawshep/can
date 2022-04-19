#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

GEM_NAME = 'can_cli'
PKG_NAME = 'can'

ci_dir = File.expand_path(File.dirname(__FILE__))
repo_root = File.expand_path(File.join(ci_dir, '..'))

require_relative File.join(repo_root, 'lib/#{PKG_NAME}/version')

VERSION = Can::VERSION

# Get the sha256sum from RubyGems
gems_api_uri = URI.parse("https://rubygems.org/api/v1/gems/#{GEM_NAME}.json")
gems_api_response = Net::HTTP.get_response(gems_api_uri)
sha256sum = JSON.parse(gems_api_response.body)["sha"]

# Get the old PKGBUILD from the AUR to find the old $pkgrel
old_pkgbuild_uri = URI.parse("https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=#{PKG_NAME}")
pkgbuild_response = Net::HTTP.get_response(old_pkgbuild_uri)

version_regex = /^pkgver=(.+?)$/
old_version = if pkgbuild_response.code == '404'
                nil
              else
                version_regex.match(pkgbuild_response.body)[1]
              end

pkgrel_regex = /^pkgrel=(\d+?)$/
old_pkgrel = if pkgbuild_response.code == '404'
               0
             else
               pkgrel_regex.match(pkgbuild_response.body)[1]
             end

new_pkgrel = if VERSION == old_version
               old_pkgrel.to_i + 1
             else
               1
             end

pkgbuild = <<~PKGBUILD
  # Maintainer: Sawyer Shepherd <contact@sawyershepherd.org>

  _gemname=#{GEM_NAME}
  pkgname=#{PKG_NAME}
  pkgver=#{VERSION}
  pkgrel=#{new_pkgrel}
  pkgdesc='Command-line trash manager'
  arch=(any)
  url='https://github.com/sawshep/#{PKG_NAME}'
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
