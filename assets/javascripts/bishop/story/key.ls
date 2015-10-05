
# A key isn't what you think it is.  A key is a name for a path of an
# item in the given story.  Each key can be either 'absolute' or
# 'relative'; if it's relative, it's relative to another key, and so
# on, unless the `resolve` function is called.
class Bishop.Story.Key
  (@name, @base) !->

  @from = (path) ->
    | _.is-string(path)                => new Bishop.Story.Key(path)
    | path instanceof Bishop.Story.Key => path
    | _                                => throw "Unknown value #{path}"

  relative:~
    -> @name[0] isnt \/

  path:~
    ->
      | @full is void => @resolve!
      | _ => @full

  resolve: ->
    | @full isnt void => @full
    | not @relative   => @full = @name
    | @base is void   => throw "Need a base to resolve"
    | otherwise       => @full = @resolve-relative!

  resolve-relative: ->
    base = | @base instanceof Bishop.Story.Key => @base.resolve!
           | _ => @base
    "#{base}/#{@name}"
      .replace(/([^.]+\/[.]{2})/g, "") # /../
      .replace(/[.]\//g, "") # /./
      .replace(/\/{2,}/g. "/") # /

  join: (name) ->
    new Key(name, this)
