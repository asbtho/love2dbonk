PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed("space") then
        local projectile = Projectile({
            x = self.entity.x,
            y = self.entity.y,
            direction = self.entity.direction,
            speed = 200
        })
        table.insert(self.dungeon.currentLevel.projectiles, projectile)
    end
end
