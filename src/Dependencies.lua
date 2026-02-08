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
require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/powerup_defs'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'
require 'src/Hitbox'
require 'src/Powerup'
require 'src/Projectile'

require 'src/world/Dungeon'
require 'src/world/FirstLevel'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/powerup/Powerup07000State'

require 'src/states/game/PlayState'

--
-- Assets
--
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/dungeon_tileset.png'),
    ['soldier-walk-right'] = love.graphics.newImage('graphics/soldier_walk_right.png'),
    ['soldier-walk-left'] = love.graphics.newImage('graphics/soldier_walk_left.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['07000'] = love.graphics.newImage('graphics/07000.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['soldier-walk-right'] = GenerateQuads(gTextures['soldier-walk-right'], 19, 19),
    ['soldier-walk-left'] = GenerateQuads(gTextures['soldier-walk-left'], 19, 19),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['07000'] = GenerateQuads(gTextures['07000'], 62, 17)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    ['shoot'] = love.audio.newSource('sounds/pew.mp3', 'static'),
    ['07000'] = love.audio.newSource('sounds/07000.mp3', 'static')
}
