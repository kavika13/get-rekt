module.exports = class Application
    constructor: ->
        @FPS = 60
        @MILLISECONDS_IN_SECOND = 1000
        @CANVAS_WIDTH = 640
        @CANVAS_HEIGHT = 480
        @IMAGE_SCALE = 2
        @testX = 0
        @testY = 0

        canvas = document.getElementsByTagName('canvas')[0]
        canvas.width = @CANVAS_WIDTH
        canvas.height = @CANVAS_HEIGHT

        @context = canvas.getContext '2d'
        @context.imageSmoothingEnabled = false

        @loadContent()

        setInterval @gameLoop, @MILLISECONDS_IN_SECOND / @FPS

    update: ->
        @testX = @testX + 1
        @testY = @testY + 1

    draw: ->
        @drawImage @backgroundImage, 0, 0
        @drawImage @personImage, @testX, @testY

    drawImage: (image, x, y) ->  # TODO: sourceX, sourceY, sourceWidth, sourceHeight
        @context.drawImage image, x * @IMAGE_SCALE, y * @IMAGE_SCALE, image.width * @IMAGE_SCALE, image.height * @IMAGE_SCALE

    loadContent: ->
        @backgroundImage = new Image()
        @backgroundImage.src = "images/bg.jpg"

        @personImage = new Image()
        @personImage.src = "images/person.png"

    gameLoop: =>  # Fat arrow so `this` is correct in callback
        @update()
        @draw()
