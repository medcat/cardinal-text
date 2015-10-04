#= require_self
#= require bishop/story/key
#= require bishop/story/dialog
#= require bishop/story/element
#= require bishop/story/cell
#= require bishop/story/place


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

  ->
    @elements = {}
    @places   = {}
    @dialogs  = []

  # Define a place.  If the place was already defined, it uses the
  # same definition as before.  Calls the given call back with the
  # place.
  place: (name, body) !->
    if @places[name] is void
      @places[name] = new Bishop.Story.Place(name)

    body.call(undefined, @places[name])

  # Adds a dialog to the list.
  dialog: (body) !->
    @dialogs.push(body)

  # Resolves all of the elements.  This iterates through all of the
  # places in the story and has it resolve the elements.  It also
  # iterates all of the dialogs, and cherry picks the right dialogs
  # to add to the elements.
  resolve: !->
    @elements = {}
    for own name, place of @places
      place.resolve-elements(this)
      @elements[place.name.path] = place

    for dialog in @dialogs
      if @language == dialog.language
        for own key, content of dialog.content
          key-path = new Bishop.Story.Key(key)
          dialog = new Bishop.Story.Dialog(content)
          @elements[key-path.path] = dialog
