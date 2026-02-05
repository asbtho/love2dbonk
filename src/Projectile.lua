Projectile = Class{}

function Projectile:init(def)
    self.direction = def.direction
    self.speed = def.speed
    self.x = def.x
    self.y = def.y
end

function Projectile:update(dt)
    if self.direction == "right" then
        self.x = self.x + self.speed * dt
    end
end

function Projectile:render()
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle('line', self.x, self.y, 2, 2)
end
