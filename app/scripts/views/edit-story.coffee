define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class EditStoryView extends Backbone.View
    template: JST['app/scripts/templates/edit-story.ejs']

    events:
        "submit #edit-story": "saveStory"

    initialize: ( params )->
        @model = params.model

        @listenToOnce( @model, "reset", @render )

        # Backbone validation
        #
        Backbone.Validation.bind( this )

    render: ->
        @$el.html( @template( @model.toJSON() ) )

        return this

    saveStory: ( e ) ->
      e.preventDefault()

      @model.set( 'title' ,$( e.target ).find( "input[name=title]" ).val() )
      @model.set( 'description' ,$( e.target ).find( "input[name=title]" ).val() )

      if @model.isValid( true )
        @model.save().then( =>
            Backbone.history.navigate( "#admin", trigger: true )
            utils.alert( "Story was successfully edited" )
        )