PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.tiles = self.dungeon.currentLevel.tiles
end

function PlayerWalkState:update(dt)
    self:changeDirection()

    if love.keyboard.isDown("space") then
        self.entity.isShooting = true
        if self.entity.bulletTimer >= 1 / self.entity.bulletsPerSecond then
            self:shoot()
            gSounds['shoot']:stop()
            gSounds['shoot']:play()
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

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - self.entity.walkSpeed * dt

            -- readjust
            self.entity.x = self.entity.x + self.entity.walkSpeed * dt
        elseif self.entity.direction == 'right' then
            -- temporarily adjust position
            self.entity.x = self.entity.x + self.entity.walkSpeed * dt

            -- readjust
            self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        elseif self.entity.direction == 'up' then
            -- temporarily adjust position
            self.entity.y = self.entity.y - self.entity.walkSpeed * dt

            -- readjust
            self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        else
            -- temporarily adjust position
            self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        
            -- readjust
            self.entity.y = self.entity.y - self.entity.walkSpeed * dt
        end
    end
end

function PlayerWalkState:changeDirection()
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end
end

function PlayerWalkState:shoot()
    local projectile = Projectile({
        x = self.entity.x + ( self.entity.width / 2 ),
        y = self.entity.y + ( self.entity.height / 2 ),
        direction = self.entity.direction,
        speed = self.entity.shootSpeed
    }, self.dungeon)
    table.insert(self.dungeon.currentLevel.projectiles, projectile)
end
