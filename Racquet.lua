--Represents the racquets that move up and down. Objective in the game to bounce to sphere back to the opponent.
Racquet = Class{}

function Racquet:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0 
end

--So the player can't go farther higher or lower than the screen with the racquet.
function Racquet:update(dt)

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(Super_Height - self.height, self.y + self.dy * dt)
    end
end

function Racquet:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end