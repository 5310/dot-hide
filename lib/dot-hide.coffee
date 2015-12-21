fs = require 'fs'


class DotHide
  atom.deserializers.add this

  hide : =>
    filePath = atom.project.getPaths()[0] + '/.hidden'
    if atom.project.contains(filePath)
      fileContent = fs.readFileSync filePath, 'utf8'
      try
        hiddenIgnoredNames = fileContent.split '\n'
        coreIgnoredNames = atom.config.get 'core.ignoredNames'
        atom.config.set 'dot-hide.savedIgnoredNames', coreIgnoredNames
        allIgnoredNames = coreIgnoredNames.concat hiddenIgnoredNames
        atom.config.set 'core.ignoredNames', allIgnoredNames
      catch error
        atom.notifications.addError "Dot Hide: .hidden file could not be read.",
          dismissable: true
    else
      atom.notifications.addInfo "Dot Hide: No .hidden file found in project root.",
        dismissable: true
    atom.config.set 'dot-hide.hidden', true

  show : =>
    savedIgnoredNames = atom.config.get 'dot-hide.savedIgnoredNames'
    if savedIgnoredNames?
      atom.config.set 'core.ignoredNames', savedIgnoredNames
    else
      atom.config.set 'core.ignoredNames', []
    atom.config.set 'dot-hide.savedIgnoredNames', []
    atom.config.set 'dot-hide.hidden', false

  toggle : =>
    if atom.config.get 'dot-hide.hidden' then @show() else @hide()


module.exports =
  config :
    autoHide :
      type : 'boolean'
      default : true
  activate: (state) ->
    @dotHide = new DotHide()
    atom.commands.add "atom-workspace", "dot-hide:show", @dotHide.show
    atom.commands.add "atom-workspace", "dot-hide:hide", @dotHide.hide
    atom.commands.add "atom-workspace", "dot-hide:toggle", @dotHide.toggle
