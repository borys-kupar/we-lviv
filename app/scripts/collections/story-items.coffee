define [
  'underscore'
  'backbone'
  '../models/story-item'
], (_, Backbone, StoryModel) ->

  class StoryItemsCollection extends Backbone.Collection
    url : "fake.json"
    model: StoryModel