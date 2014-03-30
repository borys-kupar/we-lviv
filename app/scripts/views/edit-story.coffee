define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  '../core/utils'
], ($, _, Backbone, JST, utils) ->
  class EditStoryView extends Backbone.View
    template: JST['app/scripts/templates/edit-story.ejs']

    languages: ["en", "ua"]
    fields: ['title', 'description', 'video', 'image']

    events:
        "submit #edit-story": "saveStory"
        "change input[name$='[video]']": "showVideo"
        "change input[name$='[image]']": "showImage"

    languages: ["en", "ua"]

    initialize: ( params )->
        @model = params.model

        @listenToOnce( @model, "change", @render )

        # Backbone validation
        #
        # Backbone.Validation.bind( this )

    render: ->
        videoId = []
        _.each( @languages, ( value, key ) =>
            if @model.get( value ).video
              videoId[ value ] = @createYoutubeEmbedCode( @model.get( value ).video )
            else
              videoId[ value ] = false
        )

        @$el.html( @template( model: @model.toJSON(), video: videoId, languages: @languages ) )

        @$el.foundation(
          tab:
            callback: $.noop()
        )

        new QRCode(document.getElementById("qrcode"), @model.id);

        return this

    createYoutubeEmbedCode:( link )->
        videoId = utils.getQueryParams( link, 'v' )

        return videoId

    showVideo: ( e )->
        link = $( e.target ).val()
        videoId = utils.getQueryParams( link, 'v' )
        $videoContainer = $( e.target ).parents('.content').find('.video-container')
        if ( not videoId ) or ( link is "" )
          $videoContainer.empty()
        else
          $videoContainer.html( "<iframe class='youtube-player' type='text/html' width='100%' height='385' src='http://www.youtube.com/embed/"+videoId+"' allowfullscreen frameborder='0'>
          </iframe>" )

    showImage: ( e )->
        link = $( e.target ).val()
        $imageContainer = $( e.target ).parents('.content').find('.image-container')
        if link is ""
            $imageContainer.empty()
        else
            $imageContainer.html( "<image src="+link+">" )

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
            Backbone.history.navigate( "#admin", trigger: true )
            utils.alert( "Story was successfully edited" )
        )