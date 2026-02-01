Dungeon = Class{}

function Dungeon:init(player)
    self.player = player

    self.currentLevel = FirstLevel(self.player)
end

function Dungeon:update(dt)
    self.currentLevel:update(dt)
end

function Dungeon:render()
    self.currentLevel:render()
end
