class Bishop.Story.Element
  name: void
  elements: []

  resolve-elements: (story) !->
    for element in @elements
      continue if element.name is void
      story.elements[element.name.path] = element
      if element instanceof Bishop.Story.Element
        element.resolve-elements(story)
