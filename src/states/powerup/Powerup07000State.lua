
Powerup07000State = Class{__includes = BaseState}

function Powerup07000State:init(powerup)
    self.powerup = powerup
    self.speed = 400
    self.powerup:changeAnimation('active')
end

function Powerup07000State:update(dt)
    self.powerup.x = self.powerup.x - self.speed * dt

    if self.powerup.x < 0 then
        self.powerup.ended = true
    end
end

function Powerup07000State:render()
    local anim = self.powerup.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.powerup.x - self.powerup.offsetX), math.floor(self.powerup.y - self.powerup.offsetY))
end
