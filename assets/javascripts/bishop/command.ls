class Bishop.Command

  argument-match = /^\$([0-9]+)$/
  argument-match-escape = /^\\(\$[0-9]+)$/

  @from = (value) ->
    | _.is-array(value)        => @from-array(value)
    | _.is-string(value)       => @from-string(value)
    | _.is-plain-object(value) => @from-object(value)
    | value instanceof Bishop.Action => value
    | _ => throw new Error("Unknown value")

  @from-array = (array) ->
    action = array.shift!
    new Command(action, array)

  @from-object = (object)->
    new Command(object.action, object.arguments)

  # state.quote:
  #   0 - none
  #   1 - unallowed
  #   2 - single
  #   3 - double
  @from-string = (string) ->
    components = []
    current = []
    character = "\x00"
    state =
      position: 0
      quote: 0
    increment = !->
      state.position++
    next = !->
      components.push(current.join(""))
      current := []
      state.quote = 0
      increment!
    push = !->
      current.push(character)
      increment!

    while state.position < string.length
      character = string[state.position]
      switch state.quote
      | 0 =>
        switch character
        | \' =>
          state.quote = 2
          increment!
        | \" =>
          state.quote = 3
          increment!
        | " " => next!
        | _   => push!
      | 1 =>
        switch character
        | \', \" => throw new Error("Invalid quote")
        | " "    => next!
        | _      => push!
      | 2
        switch character
        | \\ =>
          increment!
          push!
        | \' =>
          increment!
          next!
          if string[state.position] != ' ' && state.position < string.length
             throw new Error("Invalid quote")
          increment!
        | _ => push!
      | 3
        switch character
        | \\ =>
          increment!
          push!
        | \" =>
          increment!
          next!
          if string[state.position] != ' ' && state.position < string.length
             throw new Error("Invalid quote")
          increment!
        | _ => push!

    next! if current.length > 0
    @from-array(components)

  (@action, @arguments) !->

  using: (args) ->
    mapped = _.map @arguments (arg) ->
      if arg.match(argument-match)
        args[parse-int(that[1])]
      else if arg.match(argument-match-escape)
        that[1]
      else
        arg
