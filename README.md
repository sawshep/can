<h1 style="text-align: center;">can</h1>
-----------------------------

A command line implementation of the [Freedesktop XDG trash
specification](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html).

Can seeks to follow the behavior of the GNOME Files
(Nautilus) trash implementation.

## Installation

Can is available as a
[Gem](https://rubygems.org/gems/can_cli) and as an [AUR
package](https://aur.archlinux.org/packages/can).

Install Gem:
`gem install can`

Install on AUR:
`paru -S can`

## Usage

**Does not cover all options**

**Trash files**
`can foo.txt bar.txt`

**Trash directories and files**
`can -r foo.txt bar.d`

**List files in trashcan**
`can -l`

**List files in trashcan that match a regex**
`can -l '^foo'`

**View trashinfo of files**
`can -n foo.txt bar.d`

**Untrash files**
`can -u foo.txt bar.d`

**Empty files from trashcan**
`can -e foo.txt bar.d`

**Empty entire trashcan**
`can -e`
