define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class EditStoryView extends Backbone.View
    template: JST['app/scripts/templates/edit-story.ejs']

    initialize: ( params )->
        @model = params.model

        @listenToOnce( @model, "reset", @render )

        # Backbone validation
        #
        Backbone.Validation.bind( this )

    render: ->
        @$el.html( @template( @model.toJSON() ) )

        return this