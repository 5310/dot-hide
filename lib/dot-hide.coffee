fs = require 'fs'


module.exports =

  config :
    autoHide :
      description: 'Automatically append `.hidden` file at startup.'
      type : 'boolean'
      default : true

  activate: (state) ->
    @dotHide =
      if @unserialized = atom.deserializers.deserialize(state) then @unserialized
      else new DotHide()
    atom.commands.add "atom-workspace", "dot-hide:show", @dotHide.show
    atom.commands.add "atom-workspace", "dot-hide:hide", @dotHide.hide
    atom.commands.add "atom-workspace", "dot-hide:toggle", @dotHide.toggle
    @dotHide.onActivate()

  serialize: -> @dotHide.serialize()


class DotHide

  atom.deserializers.add this
  @version: 2
  @deserialize: (state) -> new DotHide(state)
  serialize: ->
    deserializer: 'DotHide'
    version: @constructor.version
    hidden: @hidden
    savedIgnoredNames: @savedIgnoredNames

  constructor: ({hidden, savedIgnoredNames} = {hidden: false, savedIgnoredNames: []}) ->
    @hidden = hidden
    @savedIgnoredNames = savedIgnoredNames
    console.log this

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
      @savedIgnoredNames = coreIgnoredNames
      collectedDotHiddenIgnoredNames = coreIgnoredNames.concat collectedDotHiddenIgnoredNames
      atom.config.set 'core.ignoredNames', collectedDotHiddenIgnoredNames
      @hidden = true

  show : =>
    savedIgnoredNames = @savedIgnoredNames
    if savedIgnoredNames?
      atom.config.set 'core.ignoredNames', savedIgnoredNames
    else
      atom.config.set 'core.ignoredNames', []
    @savedIgnoredNames = []
    @hidden = false

  toggle : =>
    if @hidden then @show() else @hide()

  onActivate : =>
    hidden = @hidden
    @show()
    if hidden and atom.config.get 'dot-hide.autoHide' then @hide()
