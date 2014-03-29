define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class ViewStoryView extends Backbone.View
    template: JST['app/scripts/templates/view-story.ejs']

    initialize: ->
        @listenTo( @model, "change", @render )

    render: ->
        @$el.html( @template( @model.toJSON() ) )

        return this