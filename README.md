# Dot Hide

Appends names from [`.hidden`](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#GNOME) to the core ignored names list if one exists on the root of an open project.

As a result, any package that makes use of the core ignored names list to hide files (such as `tree-view`) will also ignore the names in `.hidden`.

Any custom names added to the core ignored names list persists and is reverted to when the `.hidden` entries are unappended. However, any customizations made to the core ignored names list will be lost when this happens. If you want to customize your core ignored names list do so while this functionality is inactive: is set to `show` rather than `hide`.
