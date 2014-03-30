define [
  'underscore'
  'backbone'
  '../models/story'
  'hostMapping'
], (_, Backbone, StoryModel, hostMapping) ->

  class StoryItemsCollection extends Backbone.Collection
    url: hostMapping.getHostName('api') + "/stories"
    model: StoryModel