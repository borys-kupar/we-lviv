define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  '../core/utils'
], ($, _, Backbone, JST, utils) ->
  class EditStoryView extends Backbone.View
    template: JST['app/scripts/templates/edit-story.ejs']

    events:
        "submit #edit-story": "saveStory"
        "change input[name=video]": "showVideo"
        "change input[name=image]": "showImage"

    initialize: ( params )->
        @model = params.model

        @listenTo( @model, "change", @render )



        # Backbone validation
        #
        Backbone.Validation.bind( this )

    render: ->
        if @model.get( "video" )
          videoId = @createYoutubeEmbedCode( @model.get( "video" ) )
        else
          videoId = false

        @$el.html( @template( model: @model.toJSON(), video: videoId) )
        new QRCode(document.getElementById("qrcode"), @model.id);

        return this

    createYoutubeEmbedCode:( link )->
        videoId = utils.getQueryParams( link, 'v' )

        return videoId

    showVideo: ( e )->
        console.log 'show video'
        link = $( e.target ).val()
        videoId = utils.getQueryParams( link, 'v' )
        if ( not videoId ) or ( link is "" )
          @$( ".video-container" ).empty()
        else
          @$( ".video-container" ).html( "<iframe class='youtube-player' type='text/html' width='100%' height='385' src='http://www.youtube.com/embed/"+videoId+"' allowfullscreen frameborder='0'>
          </iframe>" )

    showImage: ( e )->
        console.log 'show image'
        link = $( e.target ).val()
        console.log link
        if link is ""
            @$( ".image-container" ).empty()
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
                Backbone.history.navigate( "#admin", trigger: true )
                utils.alert( "Story was successfully edited" )
            )