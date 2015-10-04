#= require bishop/story/element

class Bishop.Story.Cell.Door extends Bishop.Story.Element
  # Doors are anonymous, and thus don't have a name.
  (body) !->
    @position = void
    @cell = void
    body.call(undefined, this)
