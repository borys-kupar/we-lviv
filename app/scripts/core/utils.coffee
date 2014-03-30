define [
    "jquery"
], ( $ ) ->

    class Utils
        $template: $( "<div/>" ).attr( "data-alert", "" ).attr( "class", "alert-box hide" )

        alert: ( message, type="success" ) ->
            @$template.text( message ).removeClass( "warning" ).addClass( type )
            @$template.appendTo( ".messages .columns" )
            @$template.slideDown()
            $( "html, body" ).animate( scrollTop: 0, "fast" )

            if type is "success"
                setTimeout( =>
                    @$template.slideUp( => @$template.remove() )
                , 5000 )

        clearAlerts: ->
            $( ".messages .columns" ).empty()

        # Localstorage get
        #
        get: ( key, defaultValue = "" ) ->
            return if not Modernizr.localstorage

            value = localStorage.getItem( key )
            return if value then value else defaultValue

        # Localstorage set
        #
        set: ( key, value ) ->
            return if not Modernizr.localstorage

            localStorage.setItem( key, value )

        # Localstorage unset
        #
        unset: ( key ) ->
            return if not Modernizr.localstorage

            localStorage.removeItem( key )


        getQueryParams:( link ,paramName ) ->
            vars = []
            hashes = link.slice(link.indexOf('?') + 1).split('&')

            for i in [0..hashes.length]
                if hashes[i]
                    hash = hashes[i].split('=')
                    vars.push(hash[0])
                    vars[hash[0]] = hash[1]

            return vars[paramName]

    new Utils