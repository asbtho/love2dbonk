FirstLevel = Class{}

function FirstLevel:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self.extraWalls = true
    self:generateWallsAndFloors()

    self.entities = {}
    self:generateEntities()

    self.powerups = {}
    
    self.player = player

    self.projectiles = {}

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this FirstLevel is the next FirstLevel, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

function FirstLevel:update(dt)
    self.player:update(dt)

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]
        for j = #self.projectiles, 1, -1 do
            local projectile = self.projectiles[j]
            if not entity.dead and projectile:collides(entity) then
                gSounds['07000']:stop()
                gSounds['07000']:play()
                entity.health = entity.health - 1
                projectile.destroyed = true
                table.remove(self.projectiles, j)
                break
            end
        end

        for l = #self.powerups, 1, -1 do
            local powerup = self.powerups[l]
            if not entity.dead and powerup:collides(entity) then
                gSounds['07000']:stop()
                gSounds['07000']:play()
                entity.health = entity.health - 1
            end
        end

        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            gSounds['07000']:stop()
            gSounds['07000']:play()
            self.player:goInvulnerable(0.2)
            self.player:damage(entity.touchDamage)
        end

        if entity.health <= 0 then
            entity.dead = true
            self.player.score = self.player.score + entity.scorePoints
        elseif not entity.dead then
            entity:processAI({level = self}, dt)
            entity:update(dt)
        end
    end

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]
        if entity.dead then
            table.remove(self.entities, i)
        end
    end

    for i = #self.powerups, 1, -1 do
        local powerup = self.powerups[i]
        if powerup.ended then
            table.remove(self.powerups, i)
        else
            powerup:update(dt)
        end
    end

    for i = #self.projectiles, 1, -1 do
        local projectile = self.projectiles[i]
        if projectile.destroyed then
            table.remove(self.projectiles, i)
        else
            projectile:update(dt)
        end
    end
end

function FirstLevel:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            local drawX = (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX
            local drawY = (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY
            love.graphics.draw( gTextures['tiles'], gFrames['tiles'][tile.id], drawX, drawY )
            if debugEnabled and tile.isWall then
                self:debug(tile, drawX, drawY, x, y)
            end
        end
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    if self.player then
        self.player:render()
    end

    for p, projectile in pairs(self.projectiles) do
        projectile:render()
    end

    for p, powerup in pairs(self.powerups) do
        powerup:render()
    end

    self:renderStats()
end

function FirstLevel:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY
            local isWall = false

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
                isWall = true
                bumped = false
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
                isWall = true
                bumped = false
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
                isWall = true
                bumped = false
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
                isWall = true
                bumped = false
            else
                if self.extraWalls and math.random(100) == 1 then
                    id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
                    isWall = true
                    bumped = false
                else
                    id = TILE_FLOORS[math.random(#TILE_FLOORS)]
                end
            end
            
            table.insert(self.tiles[y], {
                id = id, isWall = isWall, bumped = bumped
            })
        end
    end
end

function FirstLevel:generateEntities()
    local types = {'skeleton'}

    for i = 1, 100 do
        local type = types[math.random(#types)]
        local entity = Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = ENTITY_DEFS[type].width,
            height = ENTITY_DEFS[type].height,
            health = ENTITY_DEFS[type].health,
            touchDamage = ENTITY_DEFS[type].touchDamage,
            scorePoints = ENTITY_DEFS[type].scorePoints
        }

        entity.stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(entity, self.tiles, self) end,
            ['idle'] = function() return EntityIdleState(entity, self.tiles) end
        }

        table.insert(self.entities, entity)
        self.entities[i]:changeState('walk')
    end
end

function FirstLevel:renderStats()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Score: "..tostring(self.player.score), VIRTUAL_WIDTH, 10)
    love.graphics.print("Health: "..tostring(self.player.health), VIRTUAL_WIDTH, 30)
    love.graphics.print("Speed: "..tostring(self.player.walkSpeed), VIRTUAL_WIDTH, 50)
end

function FirstLevel:debug(tile, drawX, drawY, x, y)
    if tile.bumped then
        love.graphics.setColor(255, 255, 0, 255)
    else
        love.graphics.setColor(255, 0, 255, 255)
    end
    love.graphics.rectangle('line', drawX, drawY, TILE_SIZE, TILE_SIZE)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print( "x:" .. x .. "\ny:" .. y, drawX, drawY, 0)
    love.graphics.print( "powerups: " .. #self.powerups, 100, 0, 0)
    love.graphics.print( "entities: " .. #self.entities, 200, 0, 0)
    love.graphics.print( "projectiles: " .. #self.projectiles, 300, 0, 0)
    if #self.entities == 1 then
        love.graphics.print( "entity dirX: " .. self.entities[1].directionX, 400, 0, 0)
        love.graphics.print( "entity dirY: " .. self.entities[1].directionY, 500, 0, 0)
    end
    
end
