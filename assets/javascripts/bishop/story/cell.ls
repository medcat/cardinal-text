#= require bishop/story/element
#= require_self
#= require bishop/story/cell/door

class Bishop.Story.Cell extends Bishop.Story.Element
  (name, body) !->
    @name = Bishop.Story.Key.from(name)
    @elements = []

    body.call(void, this)

  door: (body) !->
    door = new Bishop.Story.Cell.Door(body)
    @elements.push(door)

  cell: (name, body) !->
    cell-name = new Bishop.Story.Key(name, @name)
    cell = new Bishop.Story.Cell(cell-name, body)
    @elements.push(cell)

  character: !->
