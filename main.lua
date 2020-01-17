push = require 'push'
Class = require 'class'

require 'Racquet'
require 'Sphere'

--Actual Resolution
Box_Width = 1280
Box_Height= 720

--Emulated resolution
Super_Width = 432
Super_Height = 243

--Speed the racquet moves
Racquet_Speed = 200

--Initializes the game
function love.load()
--No filtering of pixels
    love.graphics.setDefaultFilter('nearest', 'nearest')

--Title of the game
    love.window.setTitle('Ozma Pong')

--Calls to random are always random
    math.randomseed(os.time())

--Initializes new fonts from font.ttf
    littleFont = love.graphics.newFont('font.ttf', 8)
    bigFont = love.graphics.newFont('font.ttf', 16)
    tallyFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(littleFont)

--Sound effects
    sounds = {
        ['racquet_hit'] = love.audio.newSource('sounds/racquet_hit.wav', 'static'),
        ['tally'] = love.audio.newSource('sounds/tally.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

--Initializes the emulated resolution
    push:setupScreen(Super_Width, Super_Height, Box_Width, Box_Height,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })
--Initalizes the racquets
    player1 = Racquet(10, 30, 5, 20)
    player2 = Racquet(Super_Width - 10, Super_Height - 30, 5 , 20)

--Places the sphere in the middle of screen
    sphere = Sphere(Super_Width / 2 - 2, Super_Height / 2 - 2, 4, 4)

--Initalizes tally variables
    player1Tally = 0
    player2Tally = 0

--Whoever gets scord on gets to serve the next turn. Wit either be 1 or 2.
    servingPlayer = 1

--Person who one the game
    winningPlayer = 0

--State of the game:
-- 1. 'start' (The start of the game before anything happens)
-- 2. 'serve' (Serving the ball)
-- 3. 'play' (The sphere is bouncing between racquets)
-- 4. 'gameOver' (The game is finished with a winner and can be restarted)
    gameState = 'start'

end

--Can resize the screen 
function love.resize(w, h)
    push:resize(w ,h)
end

function love.update(dt)
    if gameState == 'serve' then
-- Initialzies sphere's velocity based on the person who scored last.
        sphere.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            sphere.dx = math.random(140, 200)
        else
            sphere.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then

--Detects sphere collision with racquet.
        if sphere:collides(player1) then
            sphere.dx = -sphere.dx * 1.03
            sphere.x = player1.x + 5

--Keep velocity going in the same direction, but randomizes it.
            if sphere.dy < 0 then 
                sphere.dy = -math.random(10, 150)
            else
                sphere.dy = math.random(10, 150)
            end

            sounds['racquet_hit']:play()
        end

        if sphere:collides(player2) then
            sphere.dx = -sphere.dx * 1.03
            sphere.x = player2.x - 4

--Keep velocity going in the same direction, but randomizes it.
            if sphere.dy < 0 then 
                sphere.dy = -math.random(10, 150)
            else
                sphere.dy = math.random(10, 150)
            end
            
            sounds['racquet_hit']:play()
        end

--Detects upper and lower screen boundary collision.
        if sphere.y <= 0 then
            sphere.y = 0
            sphere.dy = -sphere.dy
            sounds['wall_hit']:play()
        end

        if sphere.y >= Super_Height - 4 then
            sphere.y = Super_Height - 4
            sphere.dy = -sphere.dy
            sounds['wall_hit']:play()
        end

--Go back to serve if the sphere goes to the edge of the screen and update the score and serving player
    if sphere.x < 0 then
        servingPlayer = 1
        player2Tally = player2Tally + 1
        sounds['tally']:play()

--If the score of 5 is reach the game is over and victory message is shown.
    if player2Tally == 5 then
        winningPlayer = 2
        gameState = 'gameOver'
    else
        gameState = 'serve'

        sphere:reset()
    end
end

        if sphere.x > Super_Width then
            servingPlayer = 2
            player1Tally = player1Tally + 1
            sounds['tally']:play()
    
        if player1Tally == 10 then
            winningPlayer = 1
            gameState = 'gameOver'
         else
            gameState = 'serve'

            sphere:reset()
        end
    end
end

    --Player 1 Movenment
    if love.keyboard.isDown('w') then
        player1.dy = -Racquet_Speed
    elseif love.keyboard.isDown('s') then
        player1.dy = Racquet_Speed
    else
        player1.dy = 0
    end

    --Player 2 Movenment
    if love.keyboard.isDown('up') then
        player2.dy = -Racquet_Speed
    elseif love.keyboard.isDown('down') then
        player2.dy = Racquet_Speed
    else
        player2.dy = 0
    end

    if gameState == 'play' then 
        sphere:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)

    if key == 'escape' then
--The function to quit the application
        love.event.quit()
--Pressing enter during the start or serve state will transtion to the next appropraiate state.
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'gameOver' then

            gameState = 'serve'

            sphere:reset()

--Reset tallies to 0
            player1Tally = 0
            player2Tally = 0

--Decide serving player as the opposite of who won.
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

--Too draw anything on the screen 
function love.draw()
    push: apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

--Renders different things depending on which part of the game you're in.
    if gameState == 'start' then
--UI messages
        love.graphics.setFont(littleFont)
        love.graphics.printf('Welcome to Ozma Pong!', 0, 10, Super_Width, 'center')
        love.graphics.printf('Hit Enter to start!', 0, 20, Super_Width, 'center')
    elseif gameState == 'serve' then
--UI messages
        love.graphics.setFont(littleFont)
        love.graphics.printf('Player ' ..tostring(servingPlayer) .. "'s serve!", 0, 10, Super_Width, 'center')
        love.graphics.printf('Hit Enter to serve!', 0, 20, Super_Width, 'center')
    elseif gameState == 'play' then
-- no messages to display in play
    elseif gameState == 'gameOver' then
--UI messages
        love.graphics.setFont(bigFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, Super_Width, 'center')
        love.graphics.printf('Hit Enter to restart the game!', 0, 30, Super_Width, 'center')
    end

--Show the score before the sphere is rendered so it can move over the text
    displayTally()

    player1: render()
    player2: render()
    sphere: render()

--Shows the FPS
    displayFPS()

--Ends drawing to push
    push: apply('end') 
end

function displayFPS()
--Tally display
    love.graphics.setFont(littleFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

--Renders the current FPS
function displayTally()
    love.graphics.setFont(tallyFont)
    love.graphics.print(tostring(player1Tally), Super_Width / 2 - 50, Super_Height / 3)
    love.graphics.print(tostring(player2Tally), Super_Width / 2 + 30, Super_Height / 3)
end