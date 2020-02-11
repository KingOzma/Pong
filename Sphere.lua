--The sphere class represent an object boucing between the 2 racquets 
--and the walls until it goes beyond one of the racquets scoring a point for the opponent.
Sphere = Class{}

function Sphere:init(x, y, width, height)
    self.speed = 1
    self.x = x
    self.y = y
    self.width = width
    self.height = height

--Tranc velocity on axises 
    self.dy = 0
    self.dx = 0
end

function Sphere:collides(racquet)
    if self.x > racquet.x + racquet.width or racquet.x > self.x + self.width then
        return false
    end

    if self.y > racquet.y + racquet.height or racquet.y > self.y + self.height then
        return false
    end

    return true
end

--Put the sphere in the middle without movenment
function Sphere:reset()
    self.x = Super_Width / 2 - 2
    self.y = Super_Height / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Sphere:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Sphere:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end