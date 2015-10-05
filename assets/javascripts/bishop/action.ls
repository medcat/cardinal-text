#= require bishop/command

class Bishop.Action
  type: \unknown
  callback: void

  (@body) !->
    @type = | _.is-string(body)   => \string
            | _.is-function(body) => \function
            | _.is-array(body)    => \array
            | _ => \unknown

  call: (story, args) ->
    compile! if @callback is void
    @callback.apply(null, [story].concat(args))

  compile: ->
    | @type == \string   => @compile-string!
    | @type == \function => @compile-function!
    | @type == \array    => @compile-array!
    | _ => throw new Error("Unknown type #{@type}")

  compile-string: ->
    console.warn """
An action was defined with a string.  This is insecure and not preferred - the
interface for defining actions with strings may change in the future, causing
this to fail.  Try defining the action in javascript or in terms of other
commands.
                 """
    @callback = new Function("story", @body)

  compile-function: ->
    @callback = @body

  compile-array: ->
    components = []
    for item in @body
      components.push(Bishop.Command.from(item))

    @body = components

    @callback = (story, args) ~>
      last = undefined
      for item in @body
        last = story.exec(item.using(args))
      last
