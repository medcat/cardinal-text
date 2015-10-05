class Texxy.Document
  (@source) ->
    @state = {}

  parse: ->
    @state =
      position: 0
      tokens: []
      buffer: []
      current: ""

    while @state.position < @source.length
      @parse-element!

  parse-element: ->
    switch @peek!
    | \\ =>
      @push!
      @parse-tag!
    | _ => @buf!

  push: !->
    token = new Texxy.Token(@state.current, this, @state.position)
    @state.tokens.push(token)

  buff: -> @state.buffer.push(@adv!)
  peek: -> @source[@state.position]
  adv: -> @source[@state.position++]
