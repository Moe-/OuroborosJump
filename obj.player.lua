
gPlayerOnGroundStopXMult = 0.70

--gPlayerGravity = 9.81 * 300
--gPlayerJumpVY = -1300

--gPlayerGravity = 9.81 * 100
--gPlayerJumpVY = -600

gPlayerGravity = 9.81 * 250
gPlayerJumpVY = -1200

gPlayerJumpStopYFriction = 0.90 -- reduce jump height when player releases jump key early

gCamAdjustSpeed = 0.1
kPlayerHideAfterDeathTime = 0.7


kDestoyBlockDelay = 0.5 -- in seconds

kGameOverDelayAfterDeath = 3 -- in seconds

gPlayerAnimationIdleRight = nil
gPlayerAnimationIdleLeft = nil
gPlayerAnimationMoveRight = nil
gPlayerAnimationMoveLeft = nil

gPlayerAnimationJumpUpLeft = nil
gPlayerAnimationJumpTurnLeft = nil
gPlayerAnimationJumpFallLeft = nil
gPlayerAnimationJumpLandLeft = nil

gPlayerAnimationJumpUpRight = nil
gPlayerAnimationJumpTurnRight = nil
gPlayerAnimationJumpFallRight = nil
gPlayerAnimationJumpLandRight = nil
gJumpEnemyKill = false
gPlayWalkSound = false

gPlayerAnimations = {}
kPlayerAnimationFrameNumbers = {
					32, 32, 32, 32, 
					4, 4, 8, 4, 12, 
					4, 4, 8, 4, 12, 
					32, 32}
kPlayerAnimationDelay = {0.06,	0.06,	0.02,	0.02, 	
						0.1,	0.1, 	0.04,	0.05,   0.99999,	
						0.1,	0.1, 	0.04,	0.05,   0.99999, 
						0.04, 0.04}
kPlayerAnimationModes = {"loop", "loop", "loop", "loop", 
						"once", "once", "loop", "once", "loop", 
						"once", "once", "loop", "once", "loop", 
						"once", "once"}
kPlayerAnimationCallbacks = { }

gPlayerStateNames = {}
gPlayerStateNames.kPlayerStateIdleRight = 1		
gPlayerStateNames.kPlayerStateIdleLeft = 2
gPlayerStateNames.kPlayerStateMoveRight = 3
gPlayerStateNames.kPlayerStateMoveLeft = 4

gPlayerStateNames.kPlayerStateJumpUpRight = 5
gPlayerStateNames.kPlayerStateJumpTurnRight = 6
gPlayerStateNames.kPlayerStateJumpFallRight = 7
gPlayerStateNames.kPlayerStateJumpLandRight = 8

gPlayerStateNames.kPlayerStateJumpUpLeft = 10
gPlayerStateNames.kPlayerStateJumpTurnLeft = 11
gPlayerStateNames.kPlayerStateJumpFallLeft = 12
gPlayerStateNames.kPlayerStateJumpLandLeft = 13

gPlayerStateNames.kPlayerStateSpawn = 15
gPlayerStateNames.kPlayerStateDied = 16		

for k,v in pairs(gPlayerStateNames) do _G[k] = v end

function PState2Txt (stateid) 
	for k,v in pairs(gPlayerStateNames) do if stateid == v then return k end end
	return "unkown"
end

gPlayerState = kPlayerStateSpawn

gPlayerKillParticleSystems = { }
gPlayerKillParticlePosition = { }
gPlayerKillParticleSystemTimeLeft = { }
gPlayerPSCur = 1

kPlayerFacingRight = 1
kPlayerFacingLeft = 2

gPlayerDirection = kPlayerFacingRight

kPlayerNumberAnimations = 8*32
function PlayerCheatStep ()
	if gMyKeyPressed["f3"] then gPlayer.x = (gMapUsedW-5)*kTileSize gPlayer.y = 5*kTileSize end
end

function PlayerInit ()
	gPlayerState = kPlayerStateSpawn
	kPlayerAnimationCallbacks = {false, false, false, false, false, callbackTurn, false, callbackLand, false, false, callbackTurn, false, callbackLand, false, callbackSpawn, callbackDied}
	kPlayerAnimationCallbacks[8] = callbackLand
	kPlayerAnimationCallbacks[13] = callbackLand
	
	gPlayerDirection = kPlayerFacingRight

	gPlayer = {x=0,y=0,vx=0,vy=0,rx=25,ry=55,drawx=-64,drawy=-64}
	gPlayer.bJumpRecharged = false
	gPlayer.vxMax = 400
	gPlayer.vxAccelPerSecond = gPlayer.vxMax * 200

	gImgPlayer		= getCachedPaddedImage("data/player_tileset.png")
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX = screen_w/2
	gCamY = screen_h/2 + 0.5*kTileSize

	local animationStartIndex = 1
	for k, v in ipairs(kPlayerAnimationFrameNumbers) do
		local callback = nil
		if (kPlayerAnimationCallbacks[k] ~= false) then
			callback = kPlayerAnimationCallbacks[k]
		end
		gPlayerAnimations[k] = newAnimation(gImgPlayer, 128, 128, kPlayerAnimationDelay[k], kPlayerNumberAnimations, animationStartIndex, animationStartIndex + kPlayerAnimationFrameNumbers[k] - 1, kPlayerAnimationCallbacks[k])
		gPlayerAnimations[k]:setMode(kPlayerAnimationModes[k])
		animationStartIndex = animationStartIndex + kPlayerAnimationFrameNumbers[k]
		print("Animation ", k, gPlayerAnimations[k])
	end	

	createPlayerParticleSystems()
end

function PlayerSpawnAtStart ()
	local startpos = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Start)
	local o = startpos[1]
	print("startpos",o and o.x,o and o.y)
	assert(o,"startpos not found on "..tostring(gMapPath))
	gPlayer.x = 0
	gPlayer.y = 0
	if (o) then gPlayer.x = o.x * kTileSize + kTileSize  gPlayer.y = o.y * kTileSize - kTileSize* 3 end
	playSFX(gSpawnSound)
end

function PlayerDraw ()
	if (gPlayer.dead_hide_after and gMyTime > gPlayer.dead_hide_after) then return end

	local x,y = 0,kTileSize*4

	--~ love.graphics.draw(gImgPlayer, gPlayer.x+gCamAddX, gPlayer.y+gCamAddY )

	--~ love.graphics.draw(gImgPlayer, x+gCamAddX, y+gCamAddY )
	--~ love.graphics.draw(gImgPlayer, screen_w/2,screen_h/2)
	
	-- draw idle animation
	local px = floor(gPlayer.x+gPlayer.drawx+gCamAddX)
	local py = floor(gPlayer.y+gPlayer.drawy+gCamAddY)
	gPlayerAnimations[gPlayerState]:draw(px, py, 0, 1,1, 0, 0)
	
	--~ local l,t,r,b = GetPlayerBBox()
	--~ local x,y = l,t	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	--~ local x,y = l,b	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	--~ local x,y = r,t	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	--~ local x,y = r,b	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	
	--~ local mx = 0.5*(l+r)
	--~ local my = 0.5*(t+b)
	for psId = 1, 12 do
		if gPlayerKillParticleSystemTimeLeft[psId] > 0 then
			love.graphics.draw(gPlayerKillParticleSystems[psId], gPlayerKillParticlePosition[psId].x + gCamAddX, gPlayerKillParticlePosition[psId].y + gCamAddY)
		end
	end
end

function DrawDebugBlock (img,tx,ty) 
	love.graphics.draw(img, tx*kTileSize+gCamAddX, ty*kTileSize+gCamAddY )
end

-- local l,t,r,b = GetPlayerBBox()
function GetPlayerBBox () local x,y,rx,ry = gPlayer.x,gPlayer.y,gPlayer.rx,gPlayer.ry return x-rx,y-ry,x+rx,y+ry end

function isWater(tileid)
	for i = 4, 11 do if tileid == 6 + 8*i then return true end end
	for i = 5, 11 do if tileid == 5 + 8*i then return true end end
	if tileid == 88 or tileid == 89 or tileid == 90 then return true end
	return false
end

function CheckPlayerTouchesDeadlyBlock ()
	local x,y,rx,ry = gPlayer.x,gPlayer.y,gPlayer.rx,gPlayer.ry
	local e = kTileSize
	local tx0,tx1 = floor((x-rx)/e),floor((x+rx)/e)
	local ty0,ty1 = floor((y-ry)/e),floor((y+ry)/e)
	for tx = tx0,tx1 do
	for ty = ty0,ty1 do
		if (IsTileDeadly(tx,ty)) then
			--~ print("player touch deadly tile",tx,ty) 
			tileid = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
			if (isWater(tileid) == true) then
				--~ print("water")
				gPlayerKillParticleSystems[12]:reset()
				gPlayerKillParticlePosition[12].x = x
				gPlayerKillParticlePosition[12].y = y + kTileSize / 2
				gPlayerKillParticleSystemTimeLeft[12] = 15.0
				love.audio.play(gSplashSound)
			else
				--~ print("floor")
				gPlayerKillParticleSystems[11]:reset()
				gPlayerKillParticlePosition[11].x = x
				gPlayerKillParticlePosition[11].y = y + kTileSize / 2
				gPlayerKillParticleSystemTimeLeft[11] = 15.0
				love.audio.play(gScreamSound)
			end
			return true 
		end
	end
	end
end
function CheckPlayerDied ()
	if (gGodMode) then return end
	local died = CheckEnemyCollision(gPlayer)
	if (died) then return true end
	if (CheckPlayerTouchesDeadlyBlock()) then return true end
end

function PlayerUpdate(dt)
	local s = 500 * dt
	PlayerCheatStep()
	
	local bPressed_Left	= 0
	local bPressed_Right	= 0
	local bPressed_Up		= 0
	local bPressed_Down	= 0
	if keyboard[kUp] == 1 or joystickbuttons[kA] == 1 or gJumpEnemyKill then
		bPressed_Up = true
	else
		bPressed_Up = false
	end
	if keyboard[kDown] == 1 or joystickaxes[kDown] == 1 then
		bPressed_Down = true
	else
		bPressed_Down = false
	end
	if keyboard[kLeft] == 1 or joystickaxes[kLeft] == 1 then 
		bPressed_Left = true
		gPlayerDirection = kPlayerFacingLeft
	else
		bPressed_Left = false
	end
	if keyboard[kRight] == 1 or joystickaxes[kRight] == 1 then
		bPressed_Right = true
		gPlayerDirection = kPlayerFacingRight
	else
		bPressed_Right = false
	end
	
	if (gPlayer.bDead) then 
		bPressed_Left = false
		bPressed_Right = false
		bPressed_Up = false
		bPressed_Down = false
	end
	
	-- apply velocity and gravity
	gPlayer.vy = gPlayer.vy + gPlayerGravity*dt
	gPlayer.x = gPlayer.x + gPlayer.vx * dt 
	gPlayer.y = gPlayer.y + gPlayer.vy * dt 
	
	HandleCollision(gPlayer)
	
	local o = gPlayer
	local bIsOnGround = gPlayer.bIsOnGround
	
	if (bIsOnGround and o.vy >= 0) then gPlayer.bJumpRecharged = true end -- jump recharged only on downward movement
	
	-- damage ground
	local ground_tx = floor((o.x)/kTileSize)
	local ground_ty = floor((o.y + o.ry + 0.1*kTileSize)/kTileSize)
	--~ CollisionDrawDebug_Add(gImgMarkTile_red,ground_tx*kTileSize,ground_ty*kTileSize)
	if (bIsOnGround) then 
		if (o.ground_tx ~= ground_tx or 
			o.ground_ty ~= ground_ty) then
			o.ground_tx  = ground_tx
			o.ground_ty  = ground_ty
			--~ GameDamageBlock(ground_tx,ground_ty)
			if (IsBlockDestructible(ground_tx,ground_ty)) then 
				gPlayerKillParticleSystems[gPlayerPSCur]:reset()
				gPlayerKillParticlePosition[gPlayerPSCur].x = o.x + kTileSize / 2
				gPlayerKillParticlePosition[gPlayerPSCur].y = o.y + kTileSize
				gPlayerKillParticleSystemTimeLeft[gPlayerPSCur] = 1.0
				gPlayerPSCur = gPlayerPSCur + 1
				playSFX(gStonesCrackingSound)
				if gPlayerPSCur == 11 then
					gPlayerPSCur = 1
				end
				InvokeLater(kDestoyBlockDelay,function () GameDamageBlock(ground_tx,ground_ty) end)
			end
		end
	end
	
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	-- jump and left-right movement
	
	if (bPressed_Up and (gPlayer.bJumpRecharged or gJumpEnemyKill)) then
		gPlayer.bJumpRecharged = false 
		gPlayer.vy = gPlayerJumpVY 
		o.ground_tx = nil
		o.ground_ty = nil
		gJumpEnemyKill = false
		playSFX(gJumpSound)
	end
	
	-- reduce jump height when player releases jump key early
	if (gPlayer.vy < 0 and (not bPressed_Up)) then 
		gPlayer.vy = gPlayer.vy * gPlayerJumpStopYFriction
	end
	
	local vxadd = 0
	local screenMin = gMinCamX - screen_w/2
--	print("player: " .. gPlayer.x .. " min " .. screenMin)
	if (bPressed_Left and gPlayer.x >= screenMin) and abs(gPlayer.x - screenMin) < screen_w then 
		vxadd = vxadd + -gPlayer.vxAccelPerSecond 
	end
	if (bPressed_Right) then 
		vxadd = vxadd +  gPlayer.vxAccelPerSecond 
	end
	
	-- xspeed accell or friction
	if (vxadd == 0) then 
		gPlayer.vx = gPlayer.vx*gPlayerOnGroundStopXMult
	else
		gPlayer.vx = gPlayer.vx + vxadd*dt
	end
	
	-- limit x speed
	gPlayer.vx = max(-gPlayer.vxMax,min(gPlayer.vxMax,gPlayer.vx))

	-- move cam to player
	
	local f = gCamAdjustSpeed
	local fi = 1-f
	
	local newCamX = fi * gCamX + f * (gPlayer.x + 0.2*screen_w)
--	print("camera: " .. newCamX .. " min " .. gMinCamX)
	if(gMinCamX <= newCamX and gCamX - gMinCamX <= screen_w) then
		gMinCamX = gCamX
		gCamX = newCamX
	end
	
	local view_y = 0.15*screen_h
	if (gPlayer.vx < -5) then view_y = 0.0*screen_h end
	gCamY = fi * gCamY + f * (gPlayer.y + view_y)
	--~ gCamX = max(screen_w/2,gCamX)
	--~ gCamY = max(screen_h/2,gCamY)

	local died = CheckPlayerDied()
	if (died) then 
		if (not gPlayer.bDead) then 
			print("PLAYER DIED!", died) 
			gPlayer.bDead = true
			
			if (kPointsPlayer > 0) then SaveHighScore(kPointsPlayer) end
			gPlayerState = kPlayerStateDied
		end
	end
	
	if (gPlayer.bDead) then gPlayer.vx = 0 end
	if (gPlayer.bDead) then gPlayer.vy = 0 end

	if gPlayWalkSound == false and gPlayer.vx ~= 0 and gPlayer.vy == 0 then
		love.audio.play(gFootstepsSound)
		gPlayWalkSound = true
	elseif gPlayWalkSound == true and (gPlayer.vx == 0 or gPlayer.vy ~= 0 
			or (bPressed_Left == false and bPressed_Right == false)) then
		love.audio.stop(gFootstepsSound)
		gPlayWalkSound = false
	end

	--~ print("bIsOnGround",bIsOnGround,"gPlayerDirection=",gPlayerDirection)
	local bWasFalling = (gPlayerState == kPlayerStateJumpFallLeft or gPlayerState == kPlayerStateJumpFallRight)
	local bWasLanding = (gPlayerState == kPlayerStateJumpLandLeft or gPlayerState == kPlayerStateJumpLandRight)
	local bWasSpawning = gPlayerState == kPlayerStateSpawn
	
	
	-- update player animation depending on state of player	
	if (gCharAnimDebugCheat) then
		-- override
	elseif (died == true or gPlayerState == kPlayerStateDied) then
		gPlayerState = kPlayerStateDied
	-- move on ground
	elseif (bIsOnGround and bPressed_Right) then
		gPlayerState = kPlayerStateMoveRight
	elseif (bIsOnGround and bPressed_Left) then
		gPlayerState = kPlayerStateMoveLeft
	-- stay in spawning
	elseif (gPlayerState == kPlayerStateSpawn) then 
		-- stay
	-- idle on ground
	elseif (bIsOnGround and (not bWasFalling) and (not bWasLanding) and gPlayerDirection == kPlayerFacingRight) then
		--~ print("gPlayerState = kPlayerStateIdleRight")
		gPlayerState = kPlayerStateIdleRight
	elseif (bIsOnGround and (not bWasFalling) and (not bWasLanding) and gPlayerDirection == kPlayerFacingLeft) then
		--~ print("gPlayerState = kPlayerStateIdleLeft")
		gPlayerState = kPlayerStateIdleLeft
	-- player jumps until he gets too slow then switch to turn
	elseif ((not bIsOnGround) and gPlayer.vy < -150) then
--		print("up fast")
		if (gPlayerDirection == kPlayerFacingLeft) then
			gPlayerState = kPlayerStateJumpUpLeft
		else
			gPlayerState = kPlayerStateJumpUpRight
		end
	-- player is on turnpoint of jump
	elseif ((not bIsOnGround) and gPlayer.vy > -150 and gPlayer.vy < 0) then
--		print("up slow")
		if (gPlayerDirection == kPlayerFacingLeft) then
			gPlayerState = kPlayerStateJumpTurnLeft
		else
			gPlayerState = kPlayerStateJumpTurnRight
		end
	elseif ((not bIsOnGround) and gPlayer.vy > 0 and (not bWasFalling)) and (not bWasSpawning) then
--		print("falling")
		if (gPlayerDirection == kPlayerFacingLeft) then
			gPlayerState = kPlayerStateJumpFallLeft
		else
			gPlayerState = kPlayerStateJumpFallRight
		end
	elseif (bIsOnGround and bWasFalling) then
--		print("landing")
		if (gPlayerDirection == kPlayerFacingLeft) then
			gPlayerState = kPlayerStateJumpLandLeft
		else
			gPlayerState = kPlayerStateJumpLandRight
		end
	end

	
	if (gPlayerState ~= gPlayerStateOld) then
--		print("gPlayerState changed",PState2Txt(gPlayerStateOld),PState2Txt(gPlayerState))
		gPlayerStateOld = gPlayerState
		--gPlayerAnimations[oldPlayerState]:stop()
		gPlayerAnimations[gPlayerState]:reset()
		gPlayerAnimations[gPlayerState]:play()
		--print("oldstate, newstate ", oldPlayerState, gPlayerState)
	end
	gPlayerAnimations[gPlayerState]:update(dt)
	
	CheckCoinCollision(gPlayer.x, gPlayer.y)

	for psId = 1, 12 do
		if(gPlayerKillParticleSystemTimeLeft[psId] > 0) then
			gPlayerKillParticleSystems[psId]:start()
			gPlayerKillParticleSystems[psId]:update(dt)
			gPlayerKillParticleSystemTimeLeft[psId] = gPlayerKillParticleSystemTimeLeft[psId] - dt
		end
	end
end

function CharAnimDebugCheat ()
--	print("CharAnimDebugCheat")
	gCharAnimDebugCheat = true
	gPlayerState = kPlayerStateIdleRight
	InvokeLater(1,function () gPlayerState = kPlayerStateJumpUpRight end)
end

function callbackSpawn(animation)
--	print("finished spawning")
	gPlayerState = kPlayerStateIdleRight
end

function callbackDied(animation)
--	print("finished dying")
	InvokeLater(kGameOverDelayAfterDeath,function () cScreenGameOver:Start() end)
end

function callbackLand(animation)
--	print("land callback")
	if (gPlayerDirection == kPlayerFacingLeft) then
--		print("land left")
		gPlayerState = kPlayerStateIdleLeft
	elseif (gPlayerDirection == kPlayerFacingRight) then
--		print("land right")
		gPlayerState = kPlayerStateIdleRight
	end
end

function callbackTurn(animation)
--	print("turn callback")
	if (gPlayerDirection == kPlayerFacingLeft) then
--		print("fall left")
		gPlayerState = kPlayerStateJumpFallLeft
	elseif (gPlayerDirection == kPlayerFacingRight) then
--		print("fall right")
		gPlayerState = kPlayerStateJumpFallRight
	end
end

function createPlayerParticleSystems()
	for psId = 1, 10 do
		id = love.image.newImageData(32, 32)
		for x = 0, 31 do
			for y = 0, 31 do
				local gradient = 1 - ((x-15)^2+(y-15)^2)/40
				id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
			end
		end
	  
		i = love.graphics.newImage(id)
		p = love.graphics.newParticleSystem(i, 256)
		p:setEmissionRate          (45 )
		p:setLifetime              (0.5)
		p:setParticleLife          (0.3, 0.55)
		p:setPosition              (0, 0)
		p:setDirection             (0)
		p:setSpread                (2.09)
		p:setSpeed                 (20, 45)
		p:setGravity               (30)
		p:setRadialAcceleration    (10)
		p:setTangentialAcceleration(0)
		p:setSize                  (1)
		p:setSizeVariation         (0.5)
		p:setRotation              (0)
		p:setSpin                  (0)
		p:setSpinVariation         (0)
		p:setColor                 (179, 56, 0, 240, 140, 48, 0, 10)
		p:stop();
		gPlayerKillParticleSystems[psId] = p
		gPlayerKillParticlePosition[psId] = { x = -500, y = -500 }
		gPlayerKillParticleSystemTimeLeft[psId] = 0
	end

	id = love.image.newImageData(32, 32)
	for x = 0, 31 do
		for y = 0, 31 do
			local gradient = 1 - ((x-15)^2+(y-15)^2)/40
			id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
		end
	end
  
	i = love.graphics.newImage(id)
	p = love.graphics.newParticleSystem(i, 256)
	p:setEmissionRate          (75 )
	p:setLifetime              (15)
	p:setParticleLife          (1.5, 3.75)
	p:setPosition              (0, 0)
	p:setDirection             (3.14)
	p:setSpread                (6.28)
	p:setSpeed                 (50, 85)
	p:setGravity               (30)
	p:setRadialAcceleration    (20)
	p:setTangentialAcceleration(10)
	p:setSize                  (0.25)
	p:setSizeVariation         (0.15)
	p:setRotation              (0)
	p:setSpin                  (0, 6.28, 1)
	p:setSpinVariation         (1)
	p:setColor                 (255, 0, 0, 255, 192, 16, 0, 10)
	p:stop();
	gPlayerKillParticleSystems[11] = p
	gPlayerKillParticlePosition[11] = { x = -500, y = -500 }
	gPlayerKillParticleSystemTimeLeft[11] = 0

	i = love.graphics.newImage(id)
	p = love.graphics.newParticleSystem(i, 256)
	p:setEmissionRate          (75 )
	p:setLifetime              (15)
	p:setParticleLife          (1.5, 3.75)
	p:setPosition              (0, 0)
	p:setDirection             (3)
	p:setSpread                (6.28)
	p:setSpeed                 (20, 50)
	p:setGravity               (30)
	p:setRadialAcceleration    (20)
	p:setTangentialAcceleration(10)
	p:setSize                  (2)
	p:setSizeVariation         (1.5)
	p:setRotation              (0)
	p:setSpin                  (1)
	p:setSpinVariation         (3)
	p:setColor                 (192, 192, 255, 255, 128, 128, 192, 10)
	p:stop();
	gPlayerKillParticleSystems[12] = p
	gPlayerKillParticlePosition[12] = { x = -500, y = -500 }
	gPlayerKillParticleSystemTimeLeft[12] = 0
end
