fs = require 'fs'

class DotHide
  atom.deserializers.add this

  hide : =>
    filePath = atom.project.getPaths()[0] + '/.hidden'
    try
      if (fs.accessSync filePath) == fs.R_OK then raise 'Dot Hide: Cannot read .hidden file'
      fileContent = fs.readFileSync filePath, 'utf8'
      try
        hiddenIgnoredNames = fileContent.split '\n'
        coreIgnoredNames = atom.config.get 'core.ignoredNames'
        atom.config.set 'dot-hide.savedIgnoredNames', coreIgnoredNames
        allIgnoredNames = coreIgnoredNames.concat hiddenIgnoredNames
        atom.config.set 'core.ignoredNames', allIgnoredNames
        atom.config.set 'dot-hide.hidden', true
      catch error
        atom.notifications.addError "Dot Hide: .hidden file could not be read.",
          dismissable: true
    catch error
      if error == 'Dot Hide: Cannot read .hidden file'
        atom.notifications.addError "Dot Hide: .hidden file could not be read.",
          dismissable: true

  show : =>
    savedIgnoredNames = atom.config.get 'dot-hide.savedIgnoredNames'
    if savedIgnoredNames?
      atom.config.set 'core.ignoredNames', savedIgnoredNames
    else
      atom.config.set 'core.ignoredNames', []
    atom.config.set 'dot-hide.savedIgnoredNames', []
    atom.config.set 'dot-hide.hidden', false

  toggle : =>
    console.log("TOGGLING")
    if atom.config.get 'dot-hide.hidden' then @show() else @hide()

  onActivate : =>
    hidden = atom.config.get 'dot-hide.hidden'
    @show()
    if hidden and atom.config.get 'dot-hide.autoHide' then @hide()


module.exports =
  config :
    autoHide :
      description: 'Automatically append `.hidden` file at startup.'
      type : 'boolean'
      default : true
  activate: (state) ->
    console.log('Dot Hide activated!')
    @dotHide = new DotHide()
    @dotHide.onActivate()
    atom.commands.add "atom-workspace", "dot-hide:show", @dotHide.show
    atom.commands.add "atom-workspace", "dot-hide:hide", @dotHide.hide
    atom.commands.add "atom-workspace", "dot-hide:toggle", @dotHide.toggle
