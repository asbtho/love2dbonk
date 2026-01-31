--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--
-- Classes
--
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/states/BaseState'

require 'src/states/game/PlayState'

--
-- Assets
--
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/dungeon_tileset.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8)
}

gSounds = {
}
