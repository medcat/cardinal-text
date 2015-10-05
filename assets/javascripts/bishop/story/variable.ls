class Bishop.Story.Variable
  VARIABLE_ANY = \any
  VARIABLE_NUMBER = \number
  VARIABLE_BOOLEAN = \boolean
  VARIABLE_STRING = \string

  NUMBER_TEST = /^[0-9]+$/
  BOOLEAN_INCLUDE = <[true t on false f off]>

  mapping =
    any: -> true
    number: (v) ->
      | _.is-string(v) => v.test(NUMBER_TEST)
      | _.is-number(v) => true
      | _.is-undefined(v) => true
      | _ => false
    boolean: (v) ->
      | _.is-string(v)  => _.includes(BOOLEAN_INCLUDE, v)
      | _.is-number(v)  => v is 0 or v is 1
      | _.is-boolean(v) => true
      | _.is-undefined(v) => true
      | _ => false
    string: (v) -> _.is-string(v) or _.is-undefined(v)

  validator: undefined

  (validator = \any, initial-value = undefined) ->
    if mapping[validator] isnt undefined
      @validator = mapping[validator]
    else if _.is-function(validator)
      @validator = validator
    else
      throw new Error("Unknown validator #{validator}")
    @_value = initial-value

  set: (value) !->
    if @validator.call(value)
      @_value = value
    else
      throw new Error("Invalid value")

  get: ->
    @_value

  value:~
    -> @_value
    (value) -> @set(value)

  call: (story, args) ->
    switch args.length
    | 1 => @set(args[0])
    | _ => @get()

  save-to: (object) ->
    object.value = @_value

  load-from: (object) ->
    @set(object.value)
