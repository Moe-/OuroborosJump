-- oruborum: the snake eating itself, endless repetition of jump+run with level becoming harder
-- sizes : player 128x64 block 64x64
-- TODO : hiscore/meter
-- TODO : game over screen 
-- TODO : partikel 
-- TODO : sounds / musik 

-- NOTE : wegen map tile grafiken 17:40 nochmal zusammensprechen


-- Initialization
--~ anim = require 'anim/anim'
--~ require"lib/TEsound"

love.filesystem.load("lib/include.lua")()
love.filesystem.load("lib.mapload.lua")()

love.filesystem.load("utils.lua")()
love.filesystem.load("obj.base.lua")()
love.filesystem.load("obj.player.lua")()
love.filesystem.load("lib.game.lua")()
love.filesystem.load("lib.collision.lua")()
love.filesystem.load("lib.button.lua")()
love.filesystem.load("lib.background.lua")()
love.filesystem.load("obj.enemy.lua")()
love.filesystem.load("obj.coin.lua")()
love.filesystem.load("screen.menu.lua")()
love.filesystem.load("screen.game.lua")()
love.filesystem.load("screen.gameover.lua")()

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

gMyTime = 0
gMyTicks = 0
function UpdateMyTicks ()
	gMyTime = love.timer.getTime()
	gMyTicks = floor(gMyTime * 1000)
end

function love.load()
	--~ for k,v in pairs(argv) do print("argv",k,v) end
	print("bla1", love.joystick)
	mapKeys()
	UpdateMyTicks()
	loadSounds()
	-- load hiscore from disk
	-- local path = love.filesystem.getSaveDirectory( )
	gHighScore = {}
	kHighScoreFile = "ouroboros-jump-hiscore.lst"
	--~ kHighScoreFile = (love.filesystem.getSaveDirectory() or "") .. "/" .. "ouroboros-jump-hiscore.lst"
	--~ print("hiscore path",kHighScoreFile)
	if (love.filesystem.exists(kHighScoreFile)) then
		gHighScore = {}
		for line in love.filesystem.lines(kHighScoreFile) do
			--~ print("hiscore line",line)
			table.insert(gHighScore,line)
		end
	end
		
	cScreenMenu:LoadData()
	cScreenGame:LoadData()
	cScreenGameOver:LoadData()

	cScreenMenu:Start()
end

function SaveHighScore (score)
	score = floor(tonumber(score) or 0)
	if (score <= 0) then return end
	gLastScore = score
	local line = tostring(os.date()).." "..tostring(score)
	table.insert(gHighScore,line)
	local data = table.concat(gHighScore,"\n")
	local bWriteOK = love.filesystem.write(kHighScoreFile, data)
	print("SaveHighScore",line,bWriteOK)
end

	
function love.keypressed( key, unicode ) 
	gMyKeyPressed[key] = true
	if key == "escape" then os.exit() end
	if key == "f12" then love.graphics.toggleFullscreen() end
	if (gCurrentScreen and gCurrentScreen.keypressed) then gCurrentScreen:keypressed( key, unicode )  end
end

function love.keyreleased( key, unicode )
	gMyKeyPressed[key] = false
	if (gCurrentScreen and gCurrentScreen.keyreleased) then gCurrentScreen:keyreleased( key, unicode )  end
end

function love.mousepressed( x, y, button )
	if (gCurrentScreen and gCurrentScreen.mousepressed) then gCurrentScreen:mousepressed( x, y, button )  end
end

function love.mousereleased( x, y, button )
	if (gCurrentScreen and gCurrentScreen.mousereleased) then gCurrentScreen:mousereleased( x, y, button )  end
end

function love.update( dt )
	UpdateMyTicks()
	if (gCurrentScreen and gCurrentScreen.update) then gCurrentScreen:update(dt)  end
	StepStepper(gMyTicks/1000)
end

function love.draw()
	UpdateMyTicks()
	if (gCurrentScreen and gCurrentScreen.draw) then gCurrentScreen:draw()  end
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
	if (gCurrentScreen and gCurrentScreen.joystickpressed) then gCurrentScreen:joystickpressed(joystick, button )  end
	joystickbuttons[button] = 1
end

function love.joystickreleased( joystick, button )
	if (gCurrentScreen and gCurrentScreen.joystickreleased) then gCurrentScreen:joystickreleased(joystick, button )  end
	joystickbuttons[button] = 0
end


gStepper = {}
function RegisterStepper (fun) gStepper[fun] = true end
function StepStepper (t) 
	for fun,v in pairs(gStepper) do 
		if (fun(t)) then gStepper[fun] = nil end 
	end -- t in seconds
end
function InvokeLater (dt,fun) 
	local ti = gMyTicks/1000 + dt 
	RegisterStepper(function (t) 
		if (t > ti) then fun() return true end 
		end) 
end -- dt in seconds from now

function loadSounds()
--	gBackgroundMusic = love.audio.newSource("data/ouroboros.ogg", "stream")
--	gBackgroundMusic:setLooping( true )
--	gBackgroundMusic:setPitch( 0.5 )
--	love.audio.play(gBackgroundMusic)
--	gBackgroundMusicLoop = love.audio.newSource("data/Loop.ogg", "stream")
--	gBackgroundMusicLoop:setLooping( true )
--	gBackgroundMusicLoop:setPitch( 0.6 )
--	love.audio.play(gBackgroundMusicLoop)
	gBackgroundAmbient = love.audio.newSource("data/newSo1124/sfx_jungle_ambi.ogg", "stream")
	gBackgroundAmbient:setLooping( true )
	love.audio.play(gBackgroundAmbient)
--	musicSong = math.random(3)
--	if musicSong == 1 then
--		gBackgroundMusic = love.audio.newSource("data/newSo1124/mx_jungle_1.ogg", "stream")
--	elseif musicSong == 2 then
--		gBackgroundMusic = love.audio.newSource("data/newSo1124/mx_jungle_2.ogg", "stream")
--	elseif musicSong == 3 then
--		gBackgroundMusic = love.audio.newSource("data/newSo1124/mx_jungle_3.ogg", "stream")
--	end
	gBackgroundMusic = love.audio.newSource("data/mx_jungle_complete.ogg", "stream")
	gBackgroundMusic:setLooping( true )
	love.audio.play(gBackgroundMusic)
	gCoinSound = love.audio.newSource("data/Coin.wav", "static")
	gCoinSound:setVolume( 0.25 )
	gJumpSound = love.audio.newSource("data/Jump.wav", "static")
	gJumpSound:setVolume( 0.25 )
	gRandomSound = love.audio.newSource("data/Random.wav", "static")
	gRandomSound:setVolume( 2.0 )
	gStonesCrackingSound = love.audio.newSource("data/stonesCracking.wav", "static")
	gSplashSound = love.audio.newSource("data/splash.wav", "static")
	gScreamSound = love.audio.newSource("data/scream.wav", "static")
	gElectricShockSound = love.audio.newSource("data/electricShock.wav", "static")
	gSpawnSound = love.audio.newSource("data/spawn.wav", "static")
	gFootstepsSound = love.audio.newSource("data/footsteps.wav", "static")
	gFootstepsSound:setLooping( true )
end
