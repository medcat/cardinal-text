#= require bishop/command

class Bishop.Story.Dialog.Item
  (@key, {@type, content}) !->
    @content = @normalize-content(content)

  normalize-content: (content) ->
    switch @type
    | \text   => content
    | \action =>
      action = new Bishop.Action(content)
      action.compile!
      action
    | \choice =>
      throw new Error("Needs an array") unless _.is-array(content)
      _.map content (item) ->
        new Bishop.Dialog.Choice(item)
    | _ => throw new Error("Unknown type #{@type}")
