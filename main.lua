-- pirate-airship with big keg o' rum game
-- todo : ballon air angle, chain connect ? destroy phys obj : payer balloon would be enough
-- todo : palmen auf inseln


-- Initialization
goo = require 'goo/goo'
anim = require 'anim/anim'
--~ require"lib/TEsound"

love.filesystem.load("lib/include.lua")()

love.filesystem.load("utils.lua")()
love.filesystem.load("obj.base.lua")()
love.filesystem.load("obj.ship.lua")()
love.filesystem.load("obj.ball.lua")()
love.filesystem.load("obj.level.lua")()
love.filesystem.load("obj.block.lua")() -- cObjBlock
love.filesystem.load("obj.cannon.lua")() -- cObjCannon
love.filesystem.load("obj.bullet.lua")() -- cObjBullet
love.filesystem.load("obj.island.lua")() -- cObjIsland
love.filesystem.load("obj.enemy.lua")() -- cObjEnemy
love.filesystem.load("obj.balloon.lua")() -- cObjEnemy
love.filesystem.load("obj.fx.lua")() -- cObjFX
love.filesystem.load("lib.game.lua")()
love.filesystem.load("lib.levelGenerator.lua")()
love.filesystem.load("lib.water.lua")()
love.filesystem.load("obj.intro.lua") ()
love.filesystem.load("sound.lua") ()

gShowDebug = false

gKeyPressed = {}

gCamX, gCamY = 0,0
gGameState = 0
timePassed = 0

gMyTicks = 0
function UpdateMyTicks () gMyTicks = floor(love.timer.getTime() * 1000) end

function love.load()
	UpdateMyTicks()
	goo:load()
	
	-- cache images
	--~ getCachedPaddedImage("Resources/enemyShip2.png")
	--~ getCachedPaddedImage("Resources/ballon_blau.png")
	--~ getCachedPaddedImage("Resources/enemyShip1.png")
	--~ getCachedPaddedImage("Resources/block2.png")
	--~ getCachedPaddedImage("Resources/ball01.png")
	--~ getCachedPaddedImage("Resources/block3.png")
	--~ getCachedPaddedImage("Resources/grass1.png")
	--~ getCachedPaddedImage("Resources/insel0.png")
	--~ getCachedPaddedImage("Resources/dot.png")
	--~ getCachedPaddedImage("Resources/insel1.png")
	--~ getCachedPaddedImage("Resources/ballon_geld.png")
	--~ getCachedPaddedImage("Resources/block1.png")
	--~ getCachedPaddedImage("Resources/grass2.png")
	--~ getCachedPaddedImage("Resources/block0.png")
	--~ getCachedPaddedImage("Resources/enemy1.png")
	--~ getCachedPaddedImage("Resources/ballon_rot.png")
	--~ getCachedPaddedImage("Resources/seil.png")
	--~ getCachedPaddedImage("Resources/ship01.png")
	--~ getCachedPaddedImage("Resources/insel2.png")
	
	GameInit()

	--~ local panel = goo.panel:new()
	--~ panel:setPos( 100, 100 )
	--~ panel:setSize( 260, 80 )
	--~ panel:setTitle( 'Please enter your nickname' )
--~ 
	--~ local input = goo.textinput:new( panel )
	--~ input:setMultiline( false )
	--~ input:setPos( 5, 20 )
	--~ input:setSize( 250, 20 )
--~ 
	--~ input:setText(	os.getenv("USERNAME") )
--~ 
	--~ local button = goo.button:new( panel )
	--~ button:setPos( 208, 53 )
	--~ button:setSize( 50, 25 )
	--~ button:setText( 'OK' )
	--~ button.onClick = function( self, button )
		--~ print( 'I have been clicked' )
	--~ end
	
	gLevel = cLevel:New(1024*5)
	
	--~ while true do
		--~ TEsound.play(gShootSounds)
		--~ TEsound.play(gHitSounds)
		--~ TEsound.play(gExplosionSounds)
	--~ end
end

function calculateSoundVolumeFromCam(x,y)
	local dist = dist2(gCamX, gCamY, x, y)
	local y = (0-1)/(1024*3) * dist + 1
	return Clamp(y, 0, 1)
end

function love.keyreleased( key, unicode )
	if (timePassed > 2) then
		E:sendEvent("keyreleased", key)
		goo:keyreleased( key, unicode )
		gKeyPressed[key] = false
	
		if gGameState == 0 then
			gGameState = 1
		end
	
		local w = love.graphics.getWidth()
		local h = love.graphics.getHeight()
		local bw,bh = 80,67
		if (key == "f1") then Spawn_Block(	rand2(0,w),rand2(0,h/2),bw,bh,"Resources/block2.png") end
		if (key == "f2") then Spawn_Cannon(	rand2(0,w),rand2(0,h/2),bw,bh,"Resources/enemy1.png") end
		if (key == "f3") then Spawn_Island(	rand2(0,w),rand2(h*0.75,h),bw*3,bh,"Resources/insel0.png") end
		if (key == "f4") then Spawn_Ship(	rand2(0,w),rand2(0,h/2),100,"Resources/enemyShip1.png") end
	end
end

function love.keypressed( key, unicode ) 
    if (timePassed > 2) then
	E:sendEvent("keypressed", key, unicode)
	goo:keypressed( key, unicode )


	    if (key == "escape") then os.exit(0) end
	    
	    if (key == "f9") then local o = GetPlayerShip() if (o) then o.hp = o.maxhp end end
	    if (key == "f10") then gShowDebug = not gShowDebug end
	    if (key == "f11") then local o = GetPlayerShip() if (o) then o:Damage(20) end end
	    if (key == "f12") then love.graphics.toggleFullscreen() end
	    if (key == " ") then gGameState = 1 end -- space

    
	gKeyPressed[key] = true
     end
end

function love.mousepressed( x, y, button )
	if (timePassed > 2) then	
		if gGameState == 0 then

		else
			goo:mousepressed( x, y, button )
		end
	end
end

function love.mousereleased( x, y, button )
	if (timePassed > 2) then
		if gGameState == 0 then
			gGameState = 1
		else
			goo:mousereleased( x, y, button )
		end
	end
end

function love.update( dt )
	timePassed = timePassed + dt

	UpdateMyTicks()
	if gGameState == 0 then
		updateIntro(dt)
	else
		gMouseX,gMouseY = love.mouse.getPosition()
	
		-- cam control
		local dx, dy = Input.keysToDirectionVector("w", "a", "s", "d")
		local camSpeed = -50
		gCamX = gCamX - dx * camSpeed
		gCamY = gCamY - dy * camSpeed

		if gMainShip then
			gCamX = math.floor(gMainShip.x - love.graphics.getWidth() / 2)
			gCamY = 0
		end

		InvokeLaterUpdate()
		goo:update(dt)
		anim:update(dt)
		GameStep(dt)
	
		gLevel:update(dt)
		
		TEsound.cleanup()
	end
	
	gIntroCloudPos1 = gIntroCloudPos1 - 1
	if gIntroCloudPos1 < -300 then
		gIntroCloudPos1 = 1024
	end
	
	gIntroCloudPos2 = gIntroCloudPos2 - 1.5
	if gIntroCloudPos2 < -300 then
		gIntroCloudPos2 = 1024
	end
	gIntroCloudPos3 = gIntroCloudPos3 - 1.25
	if gIntroCloudPos3 < -300 then
		gIntroCloudPos3 = 1024
	end
end


gbEnablePhysObjSpawn = true
function Spawn_Block	(x,y,w,h,gfx)	if (gbEnablePhysObjSpawn) then cObjBlock:New(x,y,w,h,gfx)	end end -- left top width height
function Spawn_Cannon	(x,y,w,h,gfx)	if (gbEnablePhysObjSpawn) then cObjCannon:New(x,y,w,h,gfx)	end end -- left top width height
function Spawn_Island	(x,y,w,h,gfx)	if (gbEnablePhysObjSpawn) then cObjIsland:New(x,y,w,h,gfx)	end end -- left top width height
function Spawn_Ship		(x,y,r,gfx)		if (gbEnablePhysObjSpawn) then cObjEnemy:New(x,y,r,gfx)	end end -- left top radius

function love.draw()
	UpdateMyTicks()
	if (gGameState == 0) then
		waterDraw(0,0, function()
		drawIntro()
	end)
	else
		
		
		
		love.graphics.setColor(255,255,255,255)
		--~ love.graphics.setColor(0,255,255,255)
		--love.graphics.draw(gImgBackground,0,0)
		love.graphics.setBackgroundColor(0,0,0,255)
	
		love.graphics.clear()
	
		goo:draw()
	
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(gImgBackground,0,0)

		love.graphics.setColor(255,255,255,192)
		love.graphics.draw(gImgCloud1, gIntroCloudPos1, 100)
		love.graphics.draw(gImgCloud2, gIntroCloudPos2, 50)
		love.graphics.draw(gImgCloud1, gIntroCloudPos3, 100)

		waterDraw(0,0, function()
			GameDraw()
			gLevel:draw();
		end)		
		
		local w = love.graphics.getWidth()
		local h = love.graphics.getHeight()
		local o = GetPlayerShip()
		local lives = 0
		if o then
			lives = o.hp/10
		end
		local s = 1
		love.graphics.setFont(18)

		local txt1 = o and ("Crewmen alive:") or " --- DEAD --- "
		local txt2 = "                           Distance travelled : "..floor(max(0,gCamX / 32)).."m"
		local txt3 = "Score : "..(gPlayerScore+(floor(max(0,gCamX / 32))*1000))
		love.graphics.print(txt1.."    "..txt2.."    "..txt3, 0.1*w, 0.05*h, 0 ,s,s )
		love.graphics.print("move : arrow keys or w-a-s-d, fullscreen/window : f12", 0.2*w, 0.9*h, 0 ,s,s )
		
		love.graphics.setColor(255,255,255,255)
		
		for i = 1, lives do
			love.graphics.draw (i == 1 and gImgLivesCaptain or gImgLives, 15*i+235,25)
		end

		
		if (IsGameOver()) then 
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(gImgGameover, 100, 225)	
			
			--local s = 5
			--love.graphics.setFont(24)
			--love.graphics.print("GAME OVER!", 0.1*w, 0.4*h, 0 ,s,s )
		end
	end
end
