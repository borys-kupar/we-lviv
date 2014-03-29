define [
    "jquery"
    "underscore"
    "foundation.reveal"
    "templates"
], ( $, _, Reveal, JST ) ->

    class Dialog
        template: JST[ "app/scripts/templates/template.ejs" ]

        defaultSettings:
            title: ""
            body: ""
            type: "small"
            confirmButtonText : "Yes"
            cancelButtonText : "Cancel"
            confirmOnly : false
            onConfirm: ( e ) -> return true

        constructor: ( params = {} ) ->
            settings = _.defaults( params, @defaultSettings )

            @$el = $( @template( settings ) )

            $( "body" ).append( @$el )

            @dialog = $( "#dialog" )

            @dialog.find( ".confirm" ).click( ( e ) ->
                e.preventDefault()
                settings.onConfirm()
            )

            @dialog.find( ".cancel" ).click( ( e ) =>
                e.preventDefault()
                @close()
            )

            $( document ).foundation(
                reveal:
                    close_on_background_click : false
                    closed: =>
                        @destroy()
            )

        open: ->
            @dialog.foundation( "reveal", "open" )
            return this

        setContent: ( content ) ->
            @$el.find( ".content" ).html( content )

        close: ->
            @dialog.foundation( "reveal", "close" )

        destroy: ->
            @dialog.remove()
            @dialog = null