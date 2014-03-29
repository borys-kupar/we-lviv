define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class StoryItemsView extends Backbone.View
    template: JST['app/scripts/templates/story-items.ejs']

    events:
        "click .fa-minus-circle": "deleteStory"

    initialize: ->
        @listenTo( @model, 'reset', @render )

    render: ->
        @$el.html( @template( collection: @model.toJSON() ) )

        return this

     deleteStory: ( e ) ->
        id = $( e.target ).attr( "id" )

        story = @model.get( id )

        story.destroy()
