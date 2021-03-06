define [
  'jquery'
  'underscore'
  'backbone'
  'templates'
  'core/utils'
], ($, _, Backbone, JST, utils) ->
  class ScannerView extends Backbone.View
    className: "scanner-view"
    template: JST['app/scripts/templates/scanner.ejs']
    cameraId: null

    events:
        'click #screenshot-button': 'scan'
        'click video': 'snapshot'
        'change select': 'changeLanguage'

    initialize: ->
        if typeof MediaStreamTrack is undefined
            alert 'This browser does not support MediaStreamTrack.\n\nTry Chrome Canary.'
        else

            @localMediaStream = null
            MediaStreamTrack.getSources( @getSources )

            # Callback for QR code deceoder library
            qrcode.callback = @decodeQRCodeCallback

    scan: ->
        if @localMediaStream
            @snapshot()
            return

        if navigator.getUserMedia
            navigator.getUserMedia( {
                video:
                    optional: [
                        { sourceId: @cameraId }
                    ]
            }, (stream) =>
                @$( ".scanner-header" ).hide()
                @$( "video" ).show()

                @video.src = stream
                @localMediaStream = stream
                @sizeCanvas()
                @button.find('span').text('Take a shot')
            , @onFailSoHard )
        else if navigator.webkitGetUserMedia
            navigator.webkitGetUserMedia( {
                video:
                    optional: [
                        { sourceId: @cameraId }
                    ]
            }, (stream) =>
                @$( ".scanner-header" ).hide()
                @$( "video" ).show()

                @video.src = window.webkitURL.createObjectURL(stream)
                @localMediaStream = stream
                @sizeCanvas()
                @button.find('span').text('Take a shot')
            , @onFailSoHard )
        else
            onFailSoHard({target: video})

    getSources: (sourceInfos) =>
        for i in [0..sourceInfos.length]
            sourceInfo = sourceInfos[i]

            if sourceInfo and sourceInfo.kind is 'video'
                @cameraId = sourceInfo.id

    onFailSoHard: (e) ->
        console.log 'Reeeejected!', e

    hasGetUserMedia: ->
        # Note: Opera builds are unprefixed.
        return !!(navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia)

    decode: ->
        try
            qrcode.decode()
            # Doesn't do anything in Chrome.
            @localMediaStream.stop()
        catch e
            alert e
            # alert "Can't read qr code. Please try to scan code again."
            @video.play()

    decodeQRCodeCallback: (data) ->
        window.location = data

    sizeCanvas: ->
        # video.onloadedmetadata not firing in Chrome. See crbug.com/110938.
        setTimeout( =>
            # alert @video.videoWidth
            # @canvas.width = @video.videoWidth
            # @canvas.height = @video.videoHeight
            @canvas.width = 450
            @canvas.height = 600
            # @img.height = @video.videoHeight
            # @img.width = @video.videoWidth
        , 50)

    snapshot: ->
        if @localMediaStream
            @ctx.drawImage(@video, 0, 0)
            # "image/webp" works in Chrome 18. In other browsers, this will fall back to image/png.
            # @$('img').attr('src', @canvas.toDataURL('image/webp'))

            @video.pause()

            # Decode QR code
            @decode()

    render: ->
        @$el.html( @template() )

        @video           = @$('video').get(0)
        @canvas          = @$('canvas').get(0)
        @button          = @$('#screenshot-button')
        @buttonDecode    = @$('#decode-qr')
        @img             = @$('#screenshot')
        @ctx             = @canvas.getContext('2d')

        @$('select[name=language]').val(utils.get('language', 'en')).attr('class', utils.get('language', 'en'))

        return this

    changeLanguage: (e) ->
        @$( 'select' ).attr('class', $(e.target).val() )
        utils.set('language', $(e.target).val() )