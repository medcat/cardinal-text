#= require bishop/story/place
#= require cardinal/story/places/stonebrook_dialog

Cardinal.story.place \stonebrook (stonebrook) !->
  stonebrook.cell \.southgate (southgate) !->
    southgate.door (door) !->
      door.position = \west
      door.cell = \.inn

    southgate.door (door) !->
      door.position = \north
      door.cell = \stonebrook.hall

    southgate.door (door) !->
      door.position = \east
      door.cell = \.shop

    southgate.cell \.inn (southgate-inn) !->
      southgate-inn.character \.keeper (keeper) !->
        keeper.name "Innkeep"
        keeper.dialog \.dialog
