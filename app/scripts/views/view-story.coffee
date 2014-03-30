define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  '../core/utils'
], ($, _, Backbone, JST, utils) ->
  class ViewStoryView extends Backbone.View
    template: JST['app/scripts/templates/view-story.ejs']
    className: "story-view"

    initialize: ->
        @listenTo( @model, "change", @render )

    render: ->
      if @model.get( "video" )
          videoId = @createYoutubeEmbedCode( @model.get( "video" ) )
        else
          videoId = false

        @$el.html( @template( model: @model.toJSON(), video_id: videoId ) )

        return this

    createYoutubeEmbedCode:( link )->
        videoId = utils.getQueryParams( link, 'v' )

        return videoId