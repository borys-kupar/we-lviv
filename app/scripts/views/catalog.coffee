define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class CatalogView extends Backbone.View
    template: JST['app/scripts/templates/catalog.ejs']

    initialize: ->
        @listenTo( @model, "reset", @render )

    render:->
        @$el.html( @template( model: @model.toJSON() ) )

        return this