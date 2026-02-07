Projectile = Class{}

function Projectile:init(def, dungeon)
    self.direction = def.direction
    self.speed = def.speed
    self.x = def.x
    self.y = def.y
    self.width = 2
    self.height = 2

    self.dungeon = dungeon

    self.destroyed = false
end

function Projectile:update(dt)
    if self.direction == "right" then
        self.x = self.x + self.speed * dt
    elseif self.direction == "left" then
        self.x = self.x - self.speed * dt
    elseif self.direction == "up" then
        self.y = self.y - self.speed * dt
    elseif self.direction == "down" then
        self.y = self.y + self.speed * dt
    end

    if self:collidesToWall() then
        self.destroyed = true
    end
end

function Projectile:render()
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

function Projectile:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Projectile:getTileAt(entityX, entityY)
    local tileX = math.floor(entityX / TILE_SIZE)
    local tileY = math.floor(entityY / TILE_SIZE)
    return self.dungeon.currentLevel.tiles[tileY][tileX]
end

function Projectile:collidesToWall()
    return self:getTileAt(self.x, self.y).isWall
end
