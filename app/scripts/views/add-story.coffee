define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  '../models/story'
  '../core/utils'
], ($, _, Backbone, JST, StoryModel, utils) ->
  class AddStoryView extends Backbone.View
    template: JST['app/scripts/templates/add-story.ejs']

    events:
        "submit #add-story": "saveStory"

    initialize: ( params )->
        @model = new StoryModel()

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
            console.log "success"
            Backbone.history.navigate( "#admin", trigger: true )
            utils.alert( "New user was successfully added" )
        )

