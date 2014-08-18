define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  'core/utils'
  'models/user'
  'hostMapping'
], ($, _, Backbone, JST, utils, User, hostMapping) ->
  class LoginView extends Backbone.View
    template: JST['app/scripts/templates/login.ejs']

    initialize: ->
        @model = new User()

        # Backbone validation
        #
        Backbone.Validation.bind( this )

    events:
        "submit form": "login"

    render: ->
        @$el.html( @template() )

        return this

    login: (e) ->
        e.preventDefault()

        data =
            username:       @$el.find( "[name=username]" ).val()
            password:       @$el.find( "[name=password]" ).val()

        @model.set( data )

        @model.validate()

        if @model.isValid( [ "username", "password" ] )
            $.ajax(
                url: hostMapping.getHostName('api') + "/login"
                method: "POST"
                data: data
                type: "application/json"
            ).then(
                ( data ) =>
                    Backbone.history.navigate( "admin", trigger: true )

                ( error ) ->
                    utils.alert( "Your username or password is incorrect. Please, try again.", "warning" )

            ).done()