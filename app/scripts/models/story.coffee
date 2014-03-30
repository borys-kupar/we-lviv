define [
  'underscore'
  'backbone'
], (_, Backbone) ->
  'use strict';

  class StoryModel extends Backbone.Model
      urlRoot: "http://localhost:8000/stories"

      idAttribute: "_id"

      # defaults:
      #   video : false
      #   audio: false
      #   image: false

      validation: {}