#= require bishop/story/interaction
#= require_self
#= require bishop/story/dialog/item

class Bishop.Story.Dialog extends Bishop.Story.Interaction
  (@key, {@type, @begin, content}) ->
    @content = {}
    for own key, value of content
      content-value = []
      for data in value
        content-value.push(new Bishop.Story.Dialog.Item(@key.join(key), data))
      @content[key] = content-value

  resolve-elements: (story) ->
    story.elements[@key.path] = this
    for own key, value of @content
      key-path = new Bishop.Story.Key("./#{key}", @key)
      story.elements[key-path.path] = value
