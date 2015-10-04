#= require bishop/story/element

class Bishop.Story.Place extends Bishop.Story.Element
  (name) !->
    @name = Bishop.Story.Key.from name
    @elements = []

  cell: (name, body) !->
    cell-name = new Bishop.Story.Key name, @name
    cell = new Bishop.Story.Cell cell-name, body
    @elements.push(cell)
