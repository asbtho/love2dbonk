FirstLevel = Class{}

function FirstLevel:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self.extraWalls = true
    self:generateWallsAndFloors()
    
    -- reference to player for collisions, etc.
    self.player = player

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this FirstLevel is the next FirstLevel, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
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

function FirstLevel:update(dt)
    self.player:update(dt)
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

    if self.player then
        self.player:render()
    end
end

function FirstLevel:debug(tile, drawX, drawY, x, y)
    if tile.bumped then
        love.graphics.setColor(255, 255, 0, 255)
    else
        love.graphics.setColor(255, 0, 255, 255)
    end
    love.graphics.rectangle('line', drawX, drawY, TILE_SIZE, TILE_SIZE)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print( "x:" .. x .. "\ny:" .. y, drawX, drawY, 0)
end
