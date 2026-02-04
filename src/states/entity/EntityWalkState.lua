
EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, dungeon)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.dungeon = dungeon

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)
    --self:oldCheckCollision(dt)
    self:newCheckCollision(dt)
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- debug code
    if debugEnabled then
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle('line', self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY, self.entity.width, self.entity.height)
        love.graphics.setColor(255, 255, 0, 255)
        love.graphics.rectangle('line', self.entity.x, self.entity.y, 1, 1)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print( "x: " .. math.floor(self.entity.x - self.entity.offsetX) .. " y: " .. math.floor(self.entity.y - self.entity.offsetY), self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 10, 0)
        love.graphics.print( "offsetX:" .. self.entity.offsetX, self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 30, 0)
        love.graphics.print( "offsetY:" .. self.entity.offsetY, self.entity.x - self.entity.offsetX, self.entity.y - self.entity.offsetY - 20, 0)
    end
end

function EntityWalkState:newCheckCollision(dt)
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

function EntityWalkState:getTileAt(entityX, entityY)
    local tileX = math.floor(entityX / TILE_SIZE)
    local tileY = math.floor(entityY / TILE_SIZE)
    return self.dungeon.currentLevel.tiles[tileY][tileX]
end

function EntityWalkState:collidesToWallUp()
    local halfHeight = self.entity.height / 2
    local top = self.entity.y - self.entity.offsetY + halfHeight
    local left = self.entity.x - self.entity.offsetX
    local right = self.entity.x - self.entity.offsetX + self.entity.width
    
    local tileLeftTop = self:getTileAt(left, top)
    local tileRightTop = self:getTileAt(right, top)

    if debugEnabled then
        if tileLeftTop.isWall then
            tileLeftTop.bumped = true
        end
        if tileRightTop.isWall then
            tileRightTop.bumped = true
        end
    end

    return tileLeftTop.isWall or tileRightTop.isWall
end

function EntityWalkState:collidesToWallDown()
    local left = self.entity.x - self.entity.offsetX
    local right = self.entity.x - self.entity.offsetX + self.entity.width
    local bottom = self.entity.y - self.entity.offsetY + self.entity.height + 1

    local tileLeftDown = self:getTileAt(left, bottom)
    local tileRightDown = self:getTileAt(right, bottom)

    if debugEnabled then
        if tileLeftDown.isWall then
            tileLeftDown.bumped = true
        end
        if tileRightDown.isWall then
            tileRightDown.bumped = true
        end
    end

    return tileLeftDown.isWall or tileRightDown.isWall
end

function EntityWalkState:collidesToWallLeft()
    local halfHeight = self.entity.height / 2
    local top = self.entity.y - self.entity.offsetY + halfHeight + 1
    local left = self.entity.x - self.entity.offsetX - 1
    local bottom = self.entity.y - self.entity.offsetY + self.entity.height

    local tileLeftTop = self:getTileAt(left, top)
    local tileLeftDown = self:getTileAt(left, bottom)

    if debugEnabled then
        if tileLeftTop.isWall then
            tileLeftTop.bumped = true
        end
        if tileLeftDown.isWall then
            tileLeftDown.bumped = true
        end
    end

    return tileLeftTop.isWall or tileLeftDown.isWall
end

function EntityWalkState:collidesToWallRight()
    local halfHeight = self.entity.height / 2
    local top = self.entity.y - self.entity.offsetY + halfHeight + 1
    local right = self.entity.x - self.entity.offsetX + self.entity.width + 1
    local bottom = self.entity.y - self.entity.offsetY + self.entity.height

    local tileRightTop = self:getTileAt(right, top)
    local tileRightDown = self:getTileAt(right, bottom)

    if debugEnabled then
        if tileRightTop.isWall then
            tileRightTop.bumped = true
        end
        if tileRightDown.isWall then
            tileRightDown.bumped = true
        end
    end

    return tileRightTop.isWall or tileRightDown.isWall
end
