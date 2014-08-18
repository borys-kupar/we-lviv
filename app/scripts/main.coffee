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
    "modernizr":
      exports: 'Modernizr'
    "foundation":
      deps: [
        "jquery"
        "modernizr"
      ]
      exports: "Foundation"
    "foundation.reveal":
      deps: [
        "foundation"
      ]
    "foundation.tab":
      deps: [
        "foundation"
      ]
    "jquery.serializeObject":
      deps: [
        "jquery"
      ]
  paths:
    'jquery': '../bower_components/jquery/dist/jquery'
    'hostMapping': 'vendor/hostMapping'
    'settings': 'vendor/settings'
    "jquery.serializeObject": "../bower_components/jQuery.serializeObject/jquery.serializeObject"
    'backbone': '../bower_components/backbone/backbone'
    'backbone-validation': '../bower_components/backbone-validation/dist/backbone-validation-amd'
    'underscore': '../bower_components/underscore/underscore'
    'localStorage': '../bower_components/backbone.localStorage/backbone.localStorage'
    'qrcode': 'vendor/qrcode'
    "modernizr": "../bower_components/modernizr/modernizr"
    "foundation": "../bower_components/foundation/js/foundation/foundation"
    "foundation.reveal": "../bower_components/foundation/js/foundation/foundation.reveal"
    "foundation.tab": "../bower_components/foundation/js/foundation/foundation.tab"

require [
  'jquery'
  'backbone'
  'routes/main'
  'backbone-validation'
  'localStorage'
  'qrcode'
  'foundation.reveal'
  'foundation.tab'
  "jquery.serializeObject"
], ( $, Backbone, Router , Validation, LocalStorage, qrcode, foundationReveal, foundationTab, jQuerySerializeObject ) ->

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

  # Setup default XHR options
  #
  $.ajaxSetup(
      xhrFields:
          withCredentials: true
  )

  new Router
  Backbone.history.start()
