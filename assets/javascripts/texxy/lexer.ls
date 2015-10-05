class Texxy.Lexer
  (@document)->

  perform: ->
    @state =
      position: 0
      tokens: []
      buffer: []
      current: ""

      while @state.position < @source.length
        switch @peek!
        | \\ =>
          @push!
          @adv!
          @push \escape
        | \{ =>
          @push!
          @adv!
          @push \lbrace
        | \} =>
          @push!
          @adv!
          @push \rbrace
        | _ => @buf!

      @push!
      @state.tokens

    push: (type = \text, body = undefined) !->
      if body is undefined
        body = @state.buffer.join("")
        @state.buffer = []
      token = new Texxy.Lexer.Token(type, body, @source, @state.position)
      @state.tokens.push(token)

    buff: -> @state.buffer.push(@adv!)
    peek: -> @source[@state.position]
    adv: -> @source[@state.position++]
