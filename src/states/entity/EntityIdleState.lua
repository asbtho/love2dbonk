EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    if debugEnabled then
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle('line', self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY, self.entity.width, self.entity.height)
        love.graphics.setColor(255, 255, 255, 255)
    end
end
