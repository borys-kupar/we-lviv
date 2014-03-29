define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
], ($, _, Backbone, JST) ->
  class ScannerView extends Backbone.View
    template: JST['app/scripts/templates/scanner.ejs']

    render: ->
        @$el.html( @template() )

        return this