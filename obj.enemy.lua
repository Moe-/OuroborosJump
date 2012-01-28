
gEnemiesType1 = { }
gEnemiesType2 = { }
gEnemiesType3 = { }
gEnemiesType4 = { }

kEnemyMove = 1
kEnemyDie = 2

gImgEnemy1 = nil
gImgEnemy2 = nil
gImgEnemy3 = nil
gImgEnemy4 = nil

kEnemyAnimationDelay = {0.08, 0.08}

-- maximum number of frames for each enemy type
kEnemy1NumberAnimations = {32, 24}
kEnemy2NumberAnimations = {32, 24}
kEnemy3NumberAnimations = {32, 24}
kEnemy4NumberAnimations = {32, 24}

gEnemyDyingAnimations = { }

gEnemy1Animations = { }
gEnemy2Animations = { }
gEnemy3Animations = { }
gEnemy4Animations = { }

gEnemiesListType1 = { }
gEnemiesListType2 = { }
gEnemiesListType3 = { }
gEnemiesListType4 = { }
gEnemiesKillParticleSystems = { }
gEnemiesKillParticlePosition = { }
gEnemiesKillParticleSystemTimeLeft = { }
gEnemiesPSCur = 1

kWalkSpeed = 1.0
kWalkSpeedDiag = 0,707 * kWalkSpeed
kSpawnDistance = 4

function loadEnemies()
	gEnemiesListType1 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type1)
	gEnemiesListType2 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type2)
	gEnemiesListType3 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type3)
	gEnemiesListType4 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type4)
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type1)
	for i,v in pairs(temp) do
		gEnemiesListType1[#gEnemiesListType1 + 1] = v
	end
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type2)
	for i,v in pairs(temp) do
		gEnemiesListType2[#gEnemiesListType2 + 1] = v
	end
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type3)
	for i,v in pairs(temp) do
		gEnemiesListType3[#gEnemiesListType3 + 1] = v
	end
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type4)
	for i,v in pairs(temp) do
		gEnemiesListType4[#gEnemiesListType4 + 1] = v
	end

	function comp(w1,w2)
        if w1.x > w2.x then
            return true
        end
    end
	table.sort(gEnemiesListType1, comp)
	table.sort(gEnemiesListType2, comp)
	table.sort(gEnemiesListType3, comp)
	table.sort(gEnemiesListType4, comp)
end

function EnemiesSpawnAtStart()
	gEnemiesListType1 = { }
	gEnemiesListType2 = { }
	gEnemiesListType3 = { }
	gEnemiesListType4 = { }
	gEnemiesType1 = { }
	gEnemiesType2 = { }
	gEnemiesType3 = { }
	gEnemiesType4 = { }
	loadEnemies()
	EnemiesRespawn(0)
	createEnemyParticleSystems()
end

function EnemiesRespawn(runCount)
	EnemiesRespawnTable(gEnemiesListType1, gEnemiesType1, runCount + 1)
	EnemiesRespawnTable(gEnemiesListType2, gEnemiesType2, runCount + 1)
	EnemiesRespawnTable(gEnemiesListType3, gEnemiesType3, runCount + 1)
	EnemiesRespawnTable(gEnemiesListType4, gEnemiesType4, runCount + 1)
end

function EnemiesRespawnTable(inArray, outArray, distance)
	local index = min(distance, #inArray)
	for i,v in pairs(inArray) do
		if i%kSpawnDistance == index then
			local insertIndex = #outArray + 1
			outArray[insertIndex] = {x = v.x *kTileSize}
			outArray[insertIndex].y = v.y *kTileSize
			outArray[insertIndex].walkDir = 1
			outArray[insertIndex].dX = 0
			outArray[insertIndex].dY = 0
			outArray[insertIndex].dying = false
		end
	end
end

function EnemyInit()
	gImgEnemy1		= getCachedPaddedImage("data/enemy_floater.png")
	gImgEnemy2		= getCachedPaddedImage("data/enemy_floater.png")
	gImgEnemy3		= getCachedPaddedImage("data/enemy_floater.png")
	gImgEnemy4		= getCachedPaddedImage("data/enemy_floater.png")
	
	local animationStartIndex = 1
	for k, v in pairs(kEnemy1NumberAnimations) do
		gEnemy1Animations[k] = newAnimation(gImgEnemy1, 64, 64, kEnemyAnimationDelay[k], 0, animationStartIndex, animationStartIndex + kEnemy1NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy1NumberAnimations[k]
	end

  animationStartIndex = 1
	for k, v in pairs(kEnemy2NumberAnimations) do
		gEnemy2Animations[k] = newAnimation(gImgEnemy2, 64, 64,kEnemyAnimationDelay[k], 0, animationStartIndex, animationStartIndex + kEnemy2NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy2NumberAnimations[k]
	end

	animationStartIndex = 1
	for k, v in pairs(kEnemy3NumberAnimations) do
		gEnemy3Animations[k] = newAnimation(gImgEnemy3, 64, 64, kEnemyAnimationDelay[k], 0, animationStartIndex, animationStartIndex + kEnemy3NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy3NumberAnimations[k]
	end

	animationStartIndex = 1
	for k, v in pairs(kEnemy4NumberAnimations) do
		gEnemy4Animations[k] = newAnimation(gImgEnemy4, 64, 64, kEnemyAnimationDelay[k], 0, animationStartIndex, animationStartIndex + kEnemy4NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy4NumberAnimations[k]
	end
	
end

function EnemyUpdate(dt)
	EnemyGroupUpdate(dt, gEnemiesType1)
	EnemyGroupUpdate(dt, gEnemiesType2)
	EnemyGroupUpdate(dt, gEnemiesType3)
	EnemyGroupUpdate(dt, gEnemiesType4)

	for k, v in pairs(kEnemy1NumberAnimations) do
		gEnemy1Animations[k]:update(dt)
	end
	for k, v in pairs(kEnemy2NumberAnimations) do
		gEnemy2Animations[k]:update(dt)
	end
	for k, v in pairs(kEnemy3NumberAnimations) do
		gEnemy3Animations[k]:update(dt)
	end
	for k, v in pairs(kEnemy4NumberAnimations) do
		gEnemy4Animations[k]:update(dt)
	end

	for k, v in pairs(gEnemyDyingAnimations) do
		k:update(dt)
	end
	for psId = 1, 5 do
		if(gEnemiesKillParticleSystemTimeLeft[psId] > 0) then
			gEnemiesKillParticleSystems[psId]:start()
			gEnemiesKillParticleSystems[psId]:update(dt)
			gEnemiesKillParticleSystemTimeLeft[psId] = gEnemiesKillParticleSystemTimeLeft[psId] - dt
		end
	end
end

function EnemyGroupUpdate(dt, group)
	for i,v in pairs(group) do
--		local diffX = v.x/kTileSize - floor(v.x/kTileSize + 0.5);
--		local diffY = v.y/kTileSize - floor(v.y/kTileSize + 0.5);
--		if(v.lastTiletype == 47 or tiletype == 71 or tiletype == 79) then -- left
--			diffX = -diffX;
--		end
--		if(v.lastTiletype == 31 or tiletype == 55 or tiletype == 71) then --top
--			diffY = -diffY;
--		end
		local tiletype = TiledMap_GetMapTile(floor(v.x/kTileSize + 0.05 * v.dX + 0.5),floor(v.y/kTileSize + 0.05 * v.dY + 0.5),kMapLayer_AI)
--		local tiletype = TiledMap_GetMapTile(floor((v.x + kTileSize/2)/kTileSize + 0.5)*kTileSize,floor((v.y + kTileSize/2)/kTileSize)*kTileSize,kMapLayer_AI)


--		if(diffX ~= 0 and diffY ~= 0) then
--			print("diffX " .. diffX .. " diffY " .. diffY);	
--		end
--		local dist = sqrt(diffX * diffX + diffY * diffY);
		if(tiletype == 23) then --up
			v.dX = 0
			v.dY = - kWalkSpeed * v.walkDir * kTileSize * dt
		elseif(tiletype == 31) then --right
			v.dX = kWalkSpeed * v.walkDir * kTileSize * dt
			v.dY = 0
		elseif(tiletype == 39) then --down
			v.dX = 0
			v.dY = kWalkSpeed * v.walkDir * kTileSize * dt
		elseif(tiletype == 47) then --left
			v.dX = - kWalkSpeed * v.walkDir * kTileSize * dt
			v.dY = 0
		elseif(tiletype == 55) then --upright
			v.dX = kWalkSpeedDiag * v.walkDir * kTileSize * dt
			v.dY = - kWalkSpeedDiag * v.walkDir * kTileSize * dt
		elseif(tiletype == 63) then --downright
			v.dX = kWalkSpeedDiag * v.walkDir * kTileSize * dt
			v.dY = kWalkSpeedDiag * v.walkDir * kTileSize * dt
		elseif(tiletype == 71) then --upleft
			v.dX = - kWalkSpeedDiag * v.walkDir * kTileSize * dt
			v.dY = - kWalkSpeedDiag * v.walkDir * kTileSize * dt
		elseif(tiletype == 79) then --downleft
			v.dX = - kWalkSpeedDiag * v.walkDir * kTileSize * dt
			v.dY = kWalkSpeedDiag * v.walkDir * kTileSize * dt
		elseif(tiletype == 87 and vWalkDir ~= 1) then --normal mode
			v.walkDir = 1;
			v.dX = -v.dX;
			v.dY = -v.dY;
		elseif(tiletype == 95 and vWalkDir ~= -1) then --invert mode
			v.walkDir = -1;
			v.dX = -v.dX;
			v.dY = -v.dY;
		end
		v.x = v.x + v.dX
		v.y = v.y + v.dY
	end
end

function EnemyDraw()
	for i,v in pairs(gEnemiesType1) do
		if (not gEnemiesType1[i].dying == true) then
			gEnemy1Animations[1]:draw(v.x+gCamAddX, v.y+gCamAddY)
		else 
			for key, value in pairs (gEnemyDyingAnimations) do
				if (key.groupNumber == 1 and key.enemyNumber==i) then
					key:draw(v.x+gCamAddX, v.y+gCamAddY)
				end
			end
		end
		--love.graphics.draw(gImgEnemy1, v.x+gCamAddX, v.y+gCamAddY )
--		love.graphics.draw(gImgDot, floor(v.x/kTileSize + 0.5)*kTileSize+gCamAddX, floor(v.y/kTileSize + 0.5)*kTileSize+gCamAddY )
--		love.graphics.draw(gImgDot, v.x + kTileSize/2+gCamAddX, v.y + kTileSize/2+gCamAddY )
		--~ love.graphics.draw(gImgDot, floor(v.x/kTileSize + 0.05 * v.dX + 0.5)*kTileSize +gCamAddX, floor(v.y/kTileSize + 0.05 * v.dY + 0.5)*kTileSize +gCamAddY )

	end
	for i,v in pairs(gEnemiesType2) do
		if (gEnemiesType2[i].dying == true) then
			gEnemy2Animations[2]:draw(v.x+gCamAddX, v.y+gCamAddY)
		else
			gEnemy2Animations[1]:draw(v.x+gCamAddX, v.y+gCamAddY)
		end
	end
	for i,v in pairs(gEnemiesType3) do
		if (gEnemiesType3[i].dying == true) then
			gEnemy3Animations[2]:draw(v.x+gCamAddX, v.y+gCamAddY)
		else
			gEnemy3Animations[1]:draw(v.x+gCamAddX, v.y+gCamAddY)
		end
	end
	for i,v in pairs(gEnemiesType4) do
		if (gEnemiesType4[i].dying == true) then
			gEnemy4Animations[2]:draw(v.x+gCamAddX, v.y+gCamAddY)
		else
			gEnemy4Animations[1]:draw(v.x+gCamAddX, v.y+gCamAddY)
		end
	end

	for psId = 1, 5 do
		if gEnemiesKillParticleSystemTimeLeft[psId] > 0 then
			love.graphics.draw(gEnemiesKillParticleSystems[psId], gEnemiesKillParticlePosition[psId].x + gCamAddX, gEnemiesKillParticlePosition[psId].y + gCamAddY)
		end
	end
end

function CheckEnemyCollision(player)
	local died = CheckEnemyGroupCollision(player, gEnemiesType1, gImgEnemy1, kEnemy1NumberAnimations[1], 1)
	died = died or CheckEnemyGroupCollision(player, gEnemiesType2, gImgEnemy2, kEnemy2NumberAnimations[1], 2)
	died = died or CheckEnemyGroupCollision(player, gEnemiesType3, gImgEnemy3, kEnemy3NumberAnimations[1], 3)
	died = died or CheckEnemyGroupCollision(player, gEnemiesType4, gImgEnemy4, kEnemy4NumberAnimations[1], 4)
	return died
end

function animationEnded(animation)
	print("function callback - Animation has ended")
	local group = nil
	if (animation.groupNumber == 1) then
		group = gEnemiesType1
	elseif (animation.groupNumber == 2) then
		group = gEnemiesType2
	elseif (animation.groupNumber == 3) then
		group = gEnemiesType3
	elseif (animation.groupNumber == 4) then
		group = gEnemiesType4
	end
	table.remove(group, animation.enemyNumber)
	gEnemyDyingAnimations[animation] = nil
end

function CheckEnemyGroupCollision(player, group, imgEnemy, animationStartIndex, groupNumber)
	local died = false
	for i,v in pairs(group) do
		-- only check for collision if enemy is not dying
		if (not v.dying) then
			if v.x - kTileSize/2 <= player.x and v.x + kTileSize > player.x and v.y <= player.y and v.y + kTileSize > player.y then
				if v.y + kTileSize/2 >= player.y and player.vy > 0 then
					group[i].dying = true
					local enemyDyingAnimation = newAnimation(imgEnemy, 64, 64, kEnemyAnimationDelay[2], 0, animationStartIndex, animationStartIndex + kEnemy1NumberAnimations[2] - 1, animationEnded)
					enemyDyingAnimation:setMode("once")
					enemyDyingAnimation.groupNumber = groupNumber
					enemyDyingAnimation.enemyNumber = i
					gEnemyDyingAnimations[enemyDyingAnimation] = true
					gJumpEnemyKill = true
					gEnemiesKillParticleSystems[gEnemiesPSCur]:reset()
					gEnemiesKillParticlePosition[gEnemiesPSCur].x = v.x + kTileSize / 2
					gEnemiesKillParticlePosition[gEnemiesPSCur].y = v.y + kTileSize / 2
					gEnemiesKillParticleSystemTimeLeft[gEnemiesPSCur] = 1.0
					gEnemiesPSCur = gEnemiesPSCur + 1
					if gEnemiesPSCur == 6 then
						gEnemiesPSCur = 1
					end
					kPointsPlayer = kPointsPlayer + 7500
				else
					died = true	
				end
			end
		end
	end
	return died;
end

function createEnemyParticleSystems()
	for psId = 1, 5 do
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
		p:setLifetime              (0.5)
		p:setParticleLife          (0.5, 0.75)
		p:setPosition              (0, 0)
		p:setDirection             (0)
		p:setSpread                (3.14)
		p:setSpeed                 (10, 30)
		p:setGravity               (30)
		p:setRadialAcceleration    (10)
		p:setTangentialAcceleration(0)
		p:setSize                  (1)
		p:setSizeVariation         (0.5)
		p:setRotation              (0)
		p:setSpin                  (0)
		p:setSpinVariation         (0)
		p:setColor                 (255, 50, 50, 240, 128, 256, 50, 10)
		p:stop();
		gEnemiesKillParticleSystems[psId] = p
		gEnemiesKillParticlePosition[psId] = { x = -500, y = -500 }
		gEnemiesKillParticleSystemTimeLeft[psId] = 0
	end
end
