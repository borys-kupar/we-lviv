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
        @userLang = "en"

    render: ->
      if @model.get( @userLang ).video
          videoId = @createYoutubeEmbedCode( @model.get( @userLang ).video )
        else
          videoId = false
        console.log @model
        @$el.html( @template( model: @model.toJSON(), video_id: videoId, language: @userLang ) )

        return this

    createYoutubeEmbedCode:( link )->
        videoId = utils.getQueryParams( link, 'v' )

        return videoId