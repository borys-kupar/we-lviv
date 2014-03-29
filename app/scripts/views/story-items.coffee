define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  '../core/utils'
  '../dialog/main'
], ($, _, Backbone, JST, utils, Dialog) ->
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

        dialog = new Dialog(
            title: "Are you sure you want to delete this story?"
            body: story.get( "title" )
            onConfirm: =>
                story.destroy().then( =>
                    $( e.target ).parents( "tr" ).remove()
                )

                utils.alert( "Story was successfully deleted" )

                dialog.close()
        )

        dialog.open()


