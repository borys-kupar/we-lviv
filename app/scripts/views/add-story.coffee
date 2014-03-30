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
        "change input[name=video]": "showVideo"
        "change input[name=image]": "showImage"

    initialize: ( params )->
        @model = new StoryModel()

        # Backbone validation
        #
        Backbone.Validation.bind( this )

    render: ->
        @$el.html( @template( @model.toJSON() ) )

        return this

    showVideo: ( e )->
        link = $( e.target ).val()
        videoId = utils.getQueryParams( link, 'v' )
        if ( not videoId ) or ( link is "" )
          @$( ".video-container" ).empty()
        else
          @$( ".video-container" ).html( "<iframe class='youtube-player' type='text/html' width='100%' height='385' src='http://www.youtube.com/embed/"+videoId+"' allowfullscreen frameborder='0'>
          </iframe>" )

    showImage: ( e )->
        link = $( e.target ).val()

        if link is ""
            @$( ".video-container" ).empty()
        else
            @$( ".image-container" ).html( "<image src="+link+">" )

    saveStory: ( e ) ->
      e.preventDefault()

      @model.set( 'title' ,$( e.target ).find( "input[name=title]" ).val() )
      @model.set( 'description' ,$( e.target ).find( "textarea[name=description]" ).val() )
      @model.set( 'video', $( e.target ).find( "input[name=video]" ).val() )
      @model.set( 'image', $( e.target ).find( "input[name=image]" ).val() )

      if @model.isValid( true )
        @model.save().then( =>
            Backbone.history.navigate( "#admin/edit-story/" + @model.id, trigger: true )
            utils.alert( "New story was successfully added" )
        )

