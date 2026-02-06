Projectile = Class{}

function Projectile:init(def, dungeon)
    self.direction = def.direction
    self.speed = def.speed
    self.x = def.x
    self.y = def.y

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
    love.graphics.rectangle('line', self.x, self.y, 2, 2)
end

function Projectile:getTileAt(entityX, entityY)
    local tileX = math.floor(entityX / TILE_SIZE)
    local tileY = math.floor(entityY / TILE_SIZE)
    return self.dungeon.currentLevel.tiles[tileY][tileX]
end

function Projectile:collidesToWall()
    return self:getTileAt(self.x, self.y).isWall
end
