
EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, tiles, level)
    self.entity = entity
    self.level = level
    self.entity:changeAnimation('walk-down')

    self.tiles = tiles

    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)
    if self.entity.isPlayer then
        self:playerWalk(dt)
    else
        self:enemyWalk(dt)
    end
    
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    if debugEnabled then
        self:debug()
    end
end

function EntityWalkState:enemyWalk(dt)
    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.directionHorizontal == 'left' and self.entity.directionVertical == 'up' then
        if not self:collidesToWallLeft() then
            self.entity.x = self.entity.x + self.entity.directionX * self.entity.walkSpeed * dt
        end

        if not self:collidesToWallUp() then
            self.entity.y = self.entity.y + self.entity.directionY * self.entity.walkSpeed * dt
        end
    elseif self.entity.directionHorizontal == 'left' and self.entity.directionVertical == 'down' then
        if not self:collidesToWallLeft() then
            self.entity.x = self.entity.x + self.entity.directionX * self.entity.walkSpeed * dt
        end

        if not self:collidesToWallDown() then
            self.entity.y = self.entity.y + self.entity.directionY * self.entity.walkSpeed * dt
        end
    elseif self.entity.directionHorizontal == "right" and self.entity.directionVertical == 'up' then
        if not self:collidesToWallRight() then
            self.entity.x = self.entity.x + self.entity.directionX * self.entity.walkSpeed * dt
        end

        if not self:collidesToWallUp() then
            self.entity.y = self.entity.y + self.entity.directionY * self.entity.walkSpeed * dt
        end
    elseif self.entity.directionHorizontal == "right" and self.entity.directionVertical == 'down' then
        if not self:collidesToWallRight() then
            self.entity.x = self.entity.x + self.entity.directionX * self.entity.walkSpeed * dt
        end

        if not self:collidesToWallDown() then
            self.entity.y = self.entity.y + self.entity.directionY * self.entity.walkSpeed * dt
        end
    end
end

function EntityWalkState:playerWalk(dt)
    -- assume we didn't hit a wall
    self.bumped = false

    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.direction == 'left' then
        if not self:collidesToWallLeft() then
            self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        else
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        if not self:collidesToWallRight() then
            self.entity.x = self.entity.x + self.entity.walkSpeed * dt
        else
            self.bumped = true
        end
    elseif self.entity.direction == 'up' then
        if not self:collidesToWallUp() then
            self.entity.y = self.entity.y - self.entity.walkSpeed * dt
        else
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        if not self:collidesToWallDown() then
            self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        else
            self.bumped = true
        end
    end
end

function EntityWalkState:processAI(params, dt)
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    self:directionTowardsPlayer()
    self:updateDirection()
end

function EntityWalkState:oldProcessAI(params, dt)
    local level = params.level
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:getTileAt(entityX, entityY)
    local tileX = math.floor(entityX / TILE_SIZE)
    local tileY = math.floor(entityY / TILE_SIZE)
    return self.tiles[tileY][tileX]
end

function EntityWalkState:collidesToWallUp()
    local halfHeight = self.entity.height / 2
    local halfWidth = self.entity.width / 2
    local top = self.entity.y - self.entity.offsetY + halfHeight
    local left = self.entity.x - self.entity.offsetX
    local right = self.entity.x - self.entity.offsetX + self.entity.width
    local center = self.entity.x - self.entity.offsetX + halfWidth
    
    local tileA = self:getTileAt(left, top)
    local tileB = self:getTileAt(right, top)
    local tileC = self:getTileAt(center, top)

    if debugEnabled then
        self:debugCollide(tileA, tileB, tileC)
    end

    return tileA.isWall or tileB.isWall or tileC.isWall
end

function EntityWalkState:collidesToWallDown()
    local halfWidth = self.entity.width / 2
    local left = self.entity.x - self.entity.offsetX
    local right = self.entity.x - self.entity.offsetX + self.entity.width
    local bottom = self.entity.y - self.entity.offsetY + self.entity.height + 1
    local center = self.entity.x - self.entity.offsetX + halfWidth

    local tileA = self:getTileAt(left, bottom)
    local tileB = self:getTileAt(right, bottom)
    local tileC = self:getTileAt(center, bottom)

    if debugEnabled then
        self:debugCollide(tileA, tileB, tileC)
    end

    return tileA.isWall or tileB.isWall or tileC.isWall
end

function EntityWalkState:collidesToWallLeft()
    local halfHeight = self.entity.height / 2
    local top = self.entity.y - self.entity.offsetY + halfHeight + 1
    local left = self.entity.x - self.entity.offsetX - 1
    local bottom = self.entity.y - self.entity.offsetY + self.entity.height

    local tileA = self:getTileAt(left, top)
    local tileB = self:getTileAt(left, bottom)

    if debugEnabled then
        self:debugCollide(tileA, tileB)
    end

    return tileA.isWall or tileB.isWall
end

function EntityWalkState:collidesToWallRight()
    local halfHeight = self.entity.height / 2
    local top = self.entity.y - self.entity.offsetY + halfHeight + 1
    local right = self.entity.x - self.entity.offsetX + self.entity.width + 1
    local bottom = self.entity.y - self.entity.offsetY + self.entity.height

    local tileA = self:getTileAt(right, top)
    local tileB = self:getTileAt(right, bottom)

    if debugEnabled then
        self:debugCollide(tileA, tileB)
    end

    return tileA.isWall or tileB.isWall
end

function EntityWalkState:directionTowardsPlayer()
    -- Calculate direction vector
    local dirX = self.level.player.x - self.entity.x
    local dirY = self.level.player.y - self.entity.y

    -- Normalize the direction vector
    local length = math.sqrt(dirX * dirX + dirY * dirY)
    if length > 0 then
        self.entity.directionX = dirX / length
        self.entity.directionY = dirY / length
    end
end

function EntityWalkState:updateDirection()
    if self.entity.directionX > 0 then
        self.entity.directionHorizontal = "right"
    else
        self.entity.directionHorizontal = "left"
    end

    if self.entity.directionY > 0 then
        self.entity.directionVertical = "down"
    else
        self.entity.directionVertical = "up"
    end
end

function EntityWalkState:debug()
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY, self.entity.width, self.entity.height)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle('line', self.entity.x, self.entity.y, 1, 1)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print( "x: " .. math.floor(self.entity.x - self.entity.offsetX) .. " y: " .. math.floor(self.entity.y - self.entity.offsetY), self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 10, 0)
    love.graphics.print( "offsetX:" .. self.entity.offsetX, self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 30, 0)
    love.graphics.print( "offsetY:" .. self.entity.offsetY, self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 20, 0)
end

function EntityWalkState:debugCollide(tileA, tileB, tileC)
    if tileA.isWall then
        tileA.bumped = true
    end
    if tileB.isWall then
        tileB.bumped = true
    end
    if tileC and tileC.isWall then
        tileC.bumped = true
    end
end
