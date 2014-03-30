define [
    "jquery"
], ( $ ) ->
    class Presenter

        show: ( $container, view ) ->
            $container.fadeOut( "fast", ->
                $container.html( view ).fadeIn()
            )


    # Singleton
    new Presenter