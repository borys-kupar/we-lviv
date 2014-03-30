define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  '../core/utils'
], ($, _, Backbone, JST, utils) ->
  class CatalogView extends Backbone.View
    template: JST['app/scripts/templates/catalog.ejs']
    className: "catalog"

    initialize: ->
        @listenTo( @model, "reset", @render )
        @userLang = utils.get('language', 'en');

    render: ->
        @$el.html( @template( collection: @model.toJSON(), language: @userLang ) )

        return this