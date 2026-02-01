Dungeon = Class{}

function Dungeon:init(player)
    self.player = player

    self.currentRoom = Room(self.player)
end

function Dungeon:update(dt)
    self.currentRoom:update(dt)
end

function Dungeon:render()
    self.currentRoom:render()
end
