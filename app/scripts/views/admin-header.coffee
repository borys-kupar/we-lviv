define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class AdminHeaderView extends Backbone.View
    template: JST['app/scripts/templates/admin-header.ejs']

    render:->
        @$el.html( @template() )

        return this