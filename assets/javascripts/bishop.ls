#= require_self
#= require bishop/story

callbacks = []
window.Bishop = Bishop =

  init: !->
    for cb in callbacks
      _.delay(cb)

  on-init: (cb) !->
    callbacks.push(cb)

Bishop.on-init -> console.log("Bishop init")
