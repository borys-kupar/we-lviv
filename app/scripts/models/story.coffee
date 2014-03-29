define [
  'underscore'
  'backbone'
], (_, Backbone) ->
  'use strict';

  class StoryModel extends Backbone.Model

        localStorage: new Backbone.LocalStorage("SomeCollection")

        validation:
            title:
                required: true
            description:
                required: true