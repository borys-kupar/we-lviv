define [
  'underscore'
  'backbone'
  '../models/story'
], (_, Backbone, StoryModel) ->

  class StoryItemsCollection extends Backbone.Collection
    url : "http://localhost:8000/stories"
    model: StoryModel