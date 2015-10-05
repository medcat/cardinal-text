Bishop.Story.setup (story) ->
  is-saveable = (object) ->
    _.is-function(object.save-to) and _.is-function(object.load-from)

  story.on \resolve ->
    if window.local-storage is undefined
      throw new Error("Unable to save games!")

  story.action \/game/save (story, name = \save) ->
    console.log("saving...")
    delta = {}
    for own key, value of story.elements
      if is-saveable(value)
        data = {}
        value.save-to(data)
        delta[key] = data

    json = JSON.stringify(delta)
    compressed = LZString.compress(json)
    local-storage.set-item "game[#{story.name}].save[#{name}]", compressed
    true

  story.action \/game/set (story, variable, value) ->
    story.find(variable).value = value
    true

  story.action \/game/get (story, variable) ->
    story.find(variable).value
