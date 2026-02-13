Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.health = 100
    self.shootSpeed = 400
    self.walkSpeed = 120
    
    self.bulletsPerSecond = 15
    self.countdownTime = 1 / self.bulletsPerSecond
end

function Player:update(dt)
    Entity.update(self, dt)
    self.countdownTime = self.countdownTime - dt
    if  self.countdownTime <= -1 then
        self.countdownTime = self.countdownTime + 1 / self.bulletsPerSecond
    end
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
end
