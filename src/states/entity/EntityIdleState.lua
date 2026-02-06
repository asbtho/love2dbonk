EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity, dungeon)
    self.entity = entity

    self.dungeon = dungeon

    self.waitDuration = 0
    self.waitTimer = 0

    self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    if debugEnabled then
        self:debug()
    end
end

function EntityIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end

function EntityIdleState:debug()
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY, self.entity.width, self.entity.height)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle('line', self.entity.x, self.entity.y, 1, 1)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print( "x: " .. math.floor(self.entity.x - self.entity.offsetX) .. " y: " .. math.floor(self.entity.y - self.entity.offsetY), self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 10, 0)
    love.graphics.print( "offsetX:" .. self.entity.offsetX, self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 30, 0)
    love.graphics.print( "offsetY:" .. self.entity.offsetY, self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 20, 0)
end
