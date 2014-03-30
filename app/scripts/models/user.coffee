define [
  'underscore'
  'backbone'
], (_, Backbone) ->
  'use strict';

  class UserModel extends Backbone.Model
    validation:
          username:
              required: true
          password:
              required: true