
# A key isn't what you think it is.  A key is a name for a path of an
# item in the given story.  Each key can be either 'absolute' or
# 'relative'; if it's relative, it's relative to another key, and so
# on, unless the `resolve` function is called.
class Bishop.Story.Key
  (@name, @base) !->

  @from = (path) ->
    | typeof(path) == \string =>
      new Bishop.Story.Key(path)
    | path instanceof Bishop.Story.Key =>
      path
    | otherwise =>
      throw "Unknown value #{path}"

  relative:~
    -> @name[0] is \.

  path:~
    ->
      | @full is void => @resolve!
      | _ => @full

  resolve: ->
    | @full isnt void => @full
    | not @relative   => @full = @name
    | @base is void   => throw "Need a base to resolve"
    | @base instanceof Bishop.Story.Key =>
      @full = "#{@base.resolve!}#{@name}"
    | otherwise =>
      @full = "#{@base}#{@name}"
