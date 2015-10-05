#= require bishop/story
#= require_self
#= require cardinal/story/places

Cardinal.story = story = new Bishop.Story("Cardinal")

Bishop.on-init -> story.resolve!
