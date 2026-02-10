require 'src/Dependencies'
local moonshine = require 'moonshine'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Unnamed Game')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.audio.setVolume( 0.5 )
    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.scanlines)
    effect.crt.distortionFactor = {1.06, 1.065}
    effect.scanlines.thickness = 0.2
    effect.scanlines.opacity = 0.8

    debugEnabled = false
    showFPS = true
    effectsEnabled = false

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('play')

    --gSounds['music']:setLooping(true)
    --gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    if effectsEnabled then
        effect(function()
             gStateMachine:render()
        end)
    else
        gStateMachine:render()
    end
    push:finish()
    if showFPS then
        love.showFPS()
    end
end

function love.showFPS()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setFont(gFonts['small'])
end
