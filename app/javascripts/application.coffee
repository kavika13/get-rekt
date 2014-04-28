module.exports = class Application
    constructor: ->
        @FPS = 60
        @MILLISECONDS_IN_SECOND = 1000
        @IMAGE_SCALE = 2

        @VIEWPORT_WIDTH = 320
        @VIEWPORT_HEIGHT = 240
        @viewportPixelX = 0
        @viewportPixelY = 0

        @KEY_NAME_TO_CODE_MAP = {
            'space': 32,
            'left': 37,
            'up': 38,
            'right': 39,
            'down': 40,
            'a':65,
            'w':87,
            's':83,
            'd':68,
            'p':80,
        }
        @keyStates = {}

        @TILE_WIDTH = 16
        @TILE_HEIGHT = 16

        @playerTileX = 0
        @playerTileY = 0
        @levelWidth = 128
        @levelHeight = 128

        canvas = document.getElementsByTagName('canvas')[0]
        canvas.width = @VIEWPORT_WIDTH * @IMAGE_SCALE
        canvas.height = @VIEWPORT_HEIGHT * @IMAGE_SCALE

        @context = canvas.getContext '2d'
        @context.imageSmoothingEnabled = false

        @loadContent()

        window.addEventListener 'keydown', @handleKeyboardKeyDownEvent
        window.addEventListener 'keypress', @handleKeyboardKeyPressEvent
        window.addEventListener 'keyup', @handleKeyboardKeyUpEvent
        setInterval @gameLoop, @MILLISECONDS_IN_SECOND / @FPS

    update: ->
        isLeftKeyPressed = @popKeyState 'left'
        isUpKeyPressed = @popKeyState 'up'
        isRightKeyPressed = @popKeyState 'right'
        isDownKeyPressed = @popKeyState 'down'

        if isLeftKeyPressed
            @playerTileX = @playerTileX - 1

        if isRightKeyPressed
            @playerTileX = @playerTileX + 1

        if isUpKeyPressed
            @playerTileY = @playerTileY - 1

        if isDownKeyPressed
            @playerTileY = @playerTileY + 1

        @playerTileX = if @playerTileX >= 0 then @playerTileX else 0
        @playerTileY = if @playerTileY >= 0 then @playerTileY else 0
        @playerTileX = if @playerTileX < @levelWidth then @playerTileX else @levelWidth
        @playerTileY = if @playerTileY < @levelHeight then @playerTileY else @levelHeight

        playerPixelX = @playerTileX * @TILE_WIDTH
        playerPixelY = @playerTileY * @TILE_HEIGHT

        @viewportPixelX = playerPixelX - @VIEWPORT_WIDTH / 2
        @viewportPixelY = playerPixelY - @VIEWPORT_HEIGHT / 2

        mapWidth = @levelWidth * @TILE_WIDTH
        mapHeight = @levelHeight * @TILE_HEIGHT
        @viewportPixelX = if @viewportPixelX + @VIEWPORT_WIDTH < mapWidth then @viewportPixelX else mapWidth - @VIEWPORT_WIDTH
        @viewportPixelY = if @viewportPixelY + @VIEWPORT_HEIGHT < mapHeight then @viewportPixelY else mapHeight - @VIEWPORT_HEIGHT
        @viewportPixelX = if @viewportPixelX >= 0 then @viewportPixelX else 0
        @viewportPixelY = if @viewportPixelY >= 0 then @viewportPixelY else 0

    draw: ->
        @drawImage @backgroundImage, -@viewportPixelX, -@viewportPixelY
        @drawImage @personImage, @playerTileX * @TILE_WIDTH - @viewportPixelX, (@playerTileY - 1) * @TILE_HEIGHT - @viewportPixelY

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

    popKeyState: (keyName) ->
        keyCode = @KEY_NAME_TO_CODE_MAP[keyName]
        result = @keyStates[keyCode]
        @keyStates[keyCode] = false
        return result != undefined and result

    handleKeyboardKeyDownEvent: (event) =>  # Fat arrow so `this` is correct in callback
        @keyStates[event.keyCode] = true

    handleKeyboardKeyUpEvent: (event) =>  # Fat arrow so `this` is correct in callback
        @keyStates[event.keyCode] = false
