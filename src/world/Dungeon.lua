Dungeon = Class{}

function Dungeon:init()
    self.currentRoom = Room()
end

function Dungeon:update(dt)
    self.currentRoom:update(dt)
end

function Dungeon:render()
    self.currentRoom:render()
end
