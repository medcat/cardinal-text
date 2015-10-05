#= require_self
#= require bishop/action
#= require bishop/command
#= require bishop/story/key
#= require bishop/story/dialog
#= require bishop/story/element
#= require bishop/story/cell
#= require bishop/story/place
#= require bishop/story/variable

# Actions for the game.
#= require_tree ./actions


class Bishop.Story

  # The elements of the story.  Pretty much every single interaction,
  # every single object, every single varable is stored somewhere
  # within this table.  The only question is where.
  elements: {}
  # We set the default langauge to english because that's the language
  # that I speak.  I'm sorry :( to everyone who doesn't speak it, but
  # I don't know any other language.  Thankfully, the story also has
  # support for other languages, so anyone who wants to translate it
  # can.
  language: \en

  # The name of the game.
  name: ""

  # Contains information about loading the game.  This is all of the
  # pre-resolve information; after the resolve, we don't care about
  # this.
  load:
    places: []
    actions: {}
    variables: {}
    dialogs: []

  # All callbacks defined by the story.
  callbacks: {}
  metadata: {}

  @setup = (callback) !~>
    @setup.callbacks.push(callback)
  @setup.callbacks = []

  (@name)->
    @_reset-load!
    @callbacks = {}

    for callback in @@setup.callbacks
      callback.call(null, this)

  _reset-load: -> @load =
    places: {}
    actions: {}
    variables: {}
    dialogs: []

  exec: (command) ->
    unless command instanceof Bishop.Command
      command = Bishop.Command.from(command)
    @find(command.action).call(this, command.arguments)

  find: (name) ->
    if @elements[name] is undefined
      throw new Error("No element named #{name}")

    @elements[name]

  action: (name, body) ->
    key = new Bishop.Story.Key(name)
    @load.actions[key.path] = new Bishop.Action(body)

  on: (name, cb) !->
    @callbacks[name] ||= []
    @callbacks[name].push(cb)

  trigger: (name, args) !->
    return unless @callbacks[name] isnt undefined
    for cb in @callbacks[name]
      _.defer(cb, args)

  # Define a place.  If the place was already defined, it uses the
  # same definition as before.  Calls the given call back with the
  # place.
  place: (name, body) !->
    if @load.places[name] is void
      @load.places[name] = new Bishop.Story.Place(name)

    body.call(undefined, @load.places[name])

  # Adds a dialog to the list.
  dialog: (body) !->
    @load.dialogs.push(body)

  variable: (name, validator = \any, initial-value = undefined) !->
    @load.variables[name] = new Bishop.Story.Variable(validator, initial-value)

  # Resolves all of the elements.  This iterates through all of the
  # places in the story and has it resolve the elements.  It also
  # iterates all of the dialogs, and cherry picks the right dialogs
  # to add to the elements.
  resolve: !->
    console.log("Story resolve")
    @elements = {}
    for own name, action of @load.actions
      action.compile!
      @elements[name] = action

    for own name, variable of @load.variables
      @elements[name] = variable

    for own name, place of @load.places
      place.resolve-elements(this)
      @elements[place.name.path] = place

    for dialog in @load.dialogs
      if @language == dialog.language
        for own key, content of dialog.content
          key-path = new Bishop.Story.Key(key)
          dialog = new Bishop.Story.Dialog(key-path, content)
          dialog.resolve-elements(this)

    @_reset-load!
    @trigger \resolve
