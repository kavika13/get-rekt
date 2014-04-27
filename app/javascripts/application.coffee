module.exports = class Application
    constructor: ->
        canvas = document.getElementsByTagName('canvas')[0]
        context = canvas.getContext('2d')
        canvas.width = 640
        canvas.height = 480
