-- oruborum: the snake eating itself, endless repetition of jump+run with level becoming harder
-- sizes : player 128x64 block 64x64


-- Initialization
--~ anim = require 'anim/anim'
--~ require"lib/TEsound"

love.filesystem.load("lib/include.lua")()

love.filesystem.load("utils.lua")()
love.filesystem.load("obj.base.lua")()
love.filesystem.load("obj.player.lua")()
love.filesystem.load("lib.game.lua")()
love.filesystem.load("lib.mapload.lua")()

gShowDebug = false

gKeyPressed = {}

gCamX, gCamY = 0,0
gGameState = 0
timePassed = 0

gMyTicks = 0
function UpdateMyTicks () gMyTicks = floor(love.timer.getTime() * 1000) end

function love.load()
	UpdateMyTicks()
	GameInit()
end

function love.keyreleased( key, unicode )
	--~ if (key == "f1") then end
	gKeyPressed[key] = false
end

function love.keypressed( key, unicode ) 
	gKeyPressed[key] = true
	if key == "escape" then os.exit() end
end

function love.mousepressed( x, y, button )
	DebugMouseClick(x,y,button)
end

function love.mousereleased( x, y, button )
end

function love.update( dt )
	UpdateMyTicks()
	GameStep(dt)
end

function love.draw()
	UpdateMyTicks()
	GameDraw()
end
