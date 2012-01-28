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
love.filesystem.load("lib.collision.lua")()
love.filesystem.load("lib.button.lua")()
love.filesystem.load("obj.enemy.lua")()

gShowDebug = false

gCamX, gCamY = 0,0
gGameState = 0
timePassed = 0

joystickbuttons = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
joystickaxes = {0, 0, 0, 0}
keyboard = { 0, 0, 0, 0 }
axis = { 0, 0 }

gMyKeyPressed = {}
-- this can be a value between 0 and 1 the lower the value the more sensitive the joystick will react towards input and move already for minor movements only
joysticksensitivity = 0.3

gMyTicks = 0
function UpdateMyTicks () gMyTicks = floor(love.timer.getTime() * 1000) end

function love.load()
	print("bla1", love.joystick)
	mapKeys()
	UpdateMyTicks()
	GameInit()
end

	
function love.keypressed( key, unicode ) 
	gMyKeyPressed[key] = true

	if key == "up" or key == "w" then
		keyboard[kUp] = 1
	end
	if key == "down" or key == "s" then
		keyboard[kDown] = 1
	end
	if key == "left" or key == "a" then
		keyboard[kLeft] = 1
	end
	if key == "right" or key == "d" then
		keyboard[kRight] = 1
	end

	if key == "escape" then os.exit() end
end

function love.keyreleased( key, unicode )
	gMyKeyPressed[key] = false
	if key == "up" or key == "w" then
		keyboard[kUp] = 0
	end
	if key == "down" or key == "s" then
		keyboard[kDown] = 0
	end
	if key == "left" or key == "a" then
		keyboard[kLeft] = 0
	end
	if key == "right" or key == "d" then
		keyboard[kRight] = 0
	end
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

	if (button.drawAndCheckIfClicked(10, 10, "data/button/button_text_help.png")) then
		print("click help")
	end
end

function mapKeys()
	home = os.getenv("HOME")
	if(home == nil) then
		usedOS = "windows"
	elseif(string.find(home, "/Users/") ~= nil) then
		usedOS = "mac"
	else
		usedOS = "linux"
	end

	kLeft = 1
	kRight = 2
	kUp = 3
	kDown = 4	

	if(usedOS == "mac") then
		kA = 11
		kB = 12
		kX = 13
		kY = 14
		kLB = 8
		kRB = 9
		kBack = 5
		kStart = 4
	else
		kA = 0
		kB = 1
		kX = 2
		kY = 3
		kLB = 4
		kRB = 5
		kBack = 6
		kStart = 7
	end
end

function love.joystickpressed( joystick, button )
	joystickbuttons[button] = 1
end

function love.joystickreleased( joystick, button )
	joystickbuttons[button] = 0
end
