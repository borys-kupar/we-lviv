define [
  'underscore'
  'backbone'
  'hostMapping'
], (_, Backbone, hostMapping) ->
  'use strict';

  class StoryModel extends Backbone.Model
      urlRoot: hostMapping.getHostName('api') + "/stories"

      idAttribute: "_id"

      # defaults:
      #   video : false
      #   audio: false
      #   image: false

      validation: {}