#/*global require*/
'use strict'

require.config
  shim:
    'underscore':
      exports: '_'
    'backbone':
      deps: [
        'underscore'
        'jquery'
      ]
      exports: 'Backbone'
    'backbone-validation':
      deps: [
        "backbone"
      ]
  paths:
    'jquery': '../bower_components/jquery/dist/jquery'
    'backbone': '../bower_components/backbone/backbone'
    'backbone-validation': '../bower_components/backbone-validation/dist/backbone-validation-amd'
    'underscore': '../bower_components/underscore/underscore'
    'localStorage': '../bower_components/backbone.localStorage/backbone.localStorage'


require [
  'jquery'
  'backbone'
  'routes/main'
  'backbone-validation'
  'localStorage'
], ( $, Backbone, Router , Validation, LocalStorage ) ->

  # Add custom backbone validation methods
  #
  _.extend( Validation.callbacks,
      valid: (view, attr, selector) ->
          $el = view.$( "[" + selector + '~="' + attr + '"]').removeClass( "error" )
          $el.next( ".error" ).remove()

      invalid: (view, attr, error, selector) ->
          $el = view.$( "[" + selector + '~="' + attr + '"]').addClass( "error" )

          $el.next( "small" ).remove() if $el.next( "small" ).length isnt 0

          $error = $( "<small/>" ).attr( "class", "error" ).text( error )
          $el.after( $error )
  )

  new Router
  Backbone.history.start()
