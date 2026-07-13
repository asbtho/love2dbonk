Projectile = Class{}

function Projectile:init(def, dungeon)
    self.direction = def.direction
    self.speed = def.speed
    self.x = def.x
    self.y = def.y
    self.width = 8
    self.height = 8
    self.animations = self:createAnimations(def.animations)
    self:changeAnimation('active')

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

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

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self:collidesToWall() then
        self.destroyed = true
    end
end

function Projectile:render()
    local anim = self.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.x - self.width / 2 - self.offsetX), math.floor(self.y - self.height / 2 - self.offsetY))

    if debugEnabled then
        self:debug()
    end
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

function Projectile:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Projectile:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'fireeffects',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end


function Projectile:debug()
    love.graphics.rectangle('line', math.floor(self.x - self.offsetX ), math.floor(self.y - self.offsetY), self.width, self.height)
    love.graphics.setColor(255, 255, 255, 255)
end
