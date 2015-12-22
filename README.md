# Dot Hide

Appends names from `.hidden` to the core ignored names list.

Automatically or manually appends entries from [`.hidden`](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#GNOME) to the core ignored names list if one exists on the root of the [first](https://github.com/5310/dot-hide/issues/1) open project.

Yes, it's rather hacky, but it's the easiest way to get what I want. I use to keep my projects clutter-free; I often need to edit some `.gitignore`d scratch/note files, or don't need to see some files that get pushed but are auto-generated. I use `.hidden` lists for the file browser in these cases anyway, and wanted the same for Atom.

Any custom names on the core ignored names list persist the addition, of course, and when the addition is undone it reverts to that state. However, this also means that any customizations done to the core ignored names list while the functionality is active (hiding entries from `.hidden`) is lost when it reverts.
