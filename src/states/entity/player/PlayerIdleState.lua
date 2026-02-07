PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.isDown("space") then
        self:shoot()
    end
end

function PlayerIdleState:shoot()
    local projectile = Projectile({
        x = self.entity.x + ( self.entity.width / 2 ),
        y = self.entity.y + ( self.entity.height / 2 ),
        direction = self.entity.direction,
        speed = 400
    }, self.dungeon)
    table.insert(self.dungeon.currentLevel.projectiles, projectile)
end
