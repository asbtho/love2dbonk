Powerup = Class{}

function Powerup:init(def)
    self.animations = self:createAnimations(def.animations)

    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.ended = false
end

function Powerup:update(dt)
    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Powerup:render()
    self.x, self.y = self.x, self.y
    self.stateMachine:render()
    love.graphics.setColor(1, 1, 1, 1)
    self.x, self.y = self.x, self.y

    if debugEnabled then
        self:debug()
    end
end

function Powerup:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Powerup:changeState(name)
    self.stateMachine:change(name)
end

function Powerup:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Powerup:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Powerup:debug()
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print( "x:" .. self.x .. "\ny:" .. self.y, self.x, self.y, 0)
end
