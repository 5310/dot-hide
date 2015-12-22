fs = require 'fs'

class DotHide
  atom.deserializers.add this

  hide : =>
    collectedDotHiddenIgnoredNames = []
    for project in atom.project.getPaths() #BUG: API returns list, yet isn't all open projects.
      filePath = project + '/.hidden'
      try
        if (fs.accessSync filePath) == fs.R_OK then raise 'Dot Hide: Cannot read .hidden file'
        fileContent = fs.readFileSync filePath, 'utf8'
        collectedDotHiddenIgnoredNames = collectedDotHiddenIgnoredNames.concat fileContent.split '\n'
      catch error
        atom.notifications.addError "Dot Hide: .hidden file could not be read.",
          dismissable: true
    if collectedDotHiddenIgnoredNames.length >= 0
      coreIgnoredNames = atom.config.get 'core.ignoredNames'
      atom.config.set 'dot-hide.savedIgnoredNames', coreIgnoredNames
      collectedDotHiddenIgnoredNames = coreIgnoredNames.concat collectedDotHiddenIgnoredNames
      atom.config.set 'core.ignoredNames', collectedDotHiddenIgnoredNames
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
