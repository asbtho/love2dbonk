PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0

    self.enableCamera = false

    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        
        x = VIRTUAL_WIDTH / 2 - 10,
        y = VIRTUAL_HEIGHT / 2 - 10,
        
        width = 19,
        height = 19,

        -- one heart == 2 health
        health = 6
    }

    self.dungeon = Dungeon(self.player)

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }
    self.player:changeState('idle')
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.dungeon:update(dt)

    if self.enableCamera then
        self:updateCamera()
    end
end

function PlayState:render()
    -- translate the entire view of the scene to emulate a camera
    if self.enableCamera then
        love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    end
    
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()
end

function PlayState:updateCamera()
    self.camX = self.player.x - VIRTUAL_WIDTH / 2 + 9
    self.camY = self.player.y - VIRTUAL_HEIGHT / 2 + 9
end
