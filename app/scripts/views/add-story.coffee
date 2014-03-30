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

    languages: ["en", "ua"]
    fields: ['title', 'description', 'video', 'image']

    events:
        "submit #add-story": "saveStory"
        "change input[name=video]": "showVideo"
        "change input[name=image]": "showImage"

    initialize: ( params )->
        @model = new StoryModel()

        # _.each( @languages, ( value ) =>
        #     _.each( @fields, ( field ) =>
        #         key = value + "[" + field + "]"

        #         if field is "title" or field is "description"
        #           if not @model.validation[ key ]
        #             @model.validation[ key ] = {}
        #             @model.validation[ key ].required = true
        #     )
        # )

        # # Backbone validation
        # #
        # Backbone.Validation.bind( this )

    render: ->
        @$el.html( @template( languages: @languages ) )

        @$el.foundation(
          tab:
            callback: $.noop()
        )

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

      data = $( e.target ).serializeObject()

      _.each( @languages, ( value ) =>
          if not data[ value ]
              data[ value ] = {}

          _.each( @fields, ( field ) =>
              key = value + "[" + field + "]"
              data[ value ][ field ] = data[ key ]
              delete data[ key ]
          )
      )

      @model.set( data )

      # if @model.isValid( true )
      @model.save().then( =>
          Backbone.history.navigate( "#admin/edit-story/" + @model.id, trigger: true )
          utils.alert( "New story was successfully added" )
      )

