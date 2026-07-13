PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.isDown("space") then
        self.entity.isShooting = true
        if self.entity.bulletTimer >= 1 / self.entity.bulletsPerSecond then
            self:shoot()
            gSounds['fireball']:stop()
            gSounds['fireball']:play()
            self.entity.bulletTimer = 0
        end
    end

    if love.keyboard.wasPressed("p") then
        gSounds['07000']:stop()
        gSounds['07000']:play()
        local p07000 = Powerup({
            animations = POWERUP_DEFS['07000'].animations,
            x = VIRTUAL_WIDTH,
            y = self.entity.y + ( self.entity.height / 2 ),
            width = POWERUP_DEFS['07000'].width,
            height = POWERUP_DEFS['07000'].height
        })

        p07000.stateMachine = StateMachine {
            ['07000'] = function() return Powerup07000State(p07000) end
        }
        table.insert(self.dungeon.currentLevel.powerups, p07000)
        p07000:changeState('07000')
    end
end

function PlayerIdleState:shoot()
    local fireball = Projectile({
        x = self.entity.x + ( self.entity.width / 2 ),
        y = self.entity.y + ( self.entity.height / 2 ),
        direction = self.entity.direction,
        speed = self.entity.shootSpeed,
        animations = WEAPON_DEFS['fireball'].animations
    }, self.dungeon)
    table.insert(self.dungeon.currentLevel.projectiles, fireball)
end
