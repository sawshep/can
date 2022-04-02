# can

A command line implementation of the [Freedesktop XDG trash
specification](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html).

Can seeks to follow the behavior of the GNOME Files
(Nautilus) trash implementation.

As of now, it is partially implemented. You can use Can on
multiple files---it will create an info file for each and
move each to the trash directory.

# Usage

**Does not cover all options**

## Trash files

`can foo.txt bar.d`

## List files in trashcan

`can -l`

## List files in trashcan that match a regex

`can -l '^foo'`

## View trashinfo of files

`can -n foo.txt bar.d`

## Untrash files

`can -u foo.txt bar.d`

## Empty files from trashcan

`can -e foo.txt bar.d`

## Empty entire trashcan

`can -e`
