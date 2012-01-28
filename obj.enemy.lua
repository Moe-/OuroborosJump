
gEnemiesType1 = { }
gEnemiesType2 = { }
gEnemiesType3 = { }
gEnemiesType4 = { }

kEnemyMove = 1
kEnemyDie = 2

kEnemyAnimationFrameNumbers = {48}
kEnemyAnimationDelay = {0.08}

-- maximum number of frames for each enemy type
kEnemy1NumberAnimations = {32, 16}
kEnemy2NumberAnimations = {32, 16}
kEnemy3NumberAnimations = {32, 16}
kEnemy4NumberAnimations = {32, 16}

gEnemy1Animations = {}
gEnemy2Animations = {}
gEnemy3Animations = {}
gEnemy4Animations = {}

gEnemyState = kEnemyMove

gEnemiesListType1 = { }
gEnemiesListType2 = { }
gEnemiesListType3 = { }
gEnemiesListType4 = { }

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
	loadEnemies()
	EnemiesRespawn(0)
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
		end
	end
end

function EnemyInit()
	gImgEnemy1		= getCachedPaddedImage("data/enemy_floater.png")
	gImgEnemy2		= getCachedPaddedImage("data/enemy_floater.png")
	gImgEnemy3		= getCachedPaddedImage("data/enemy_floater.png")
	gImgEnemy4		= getCachedPaddedImage("data/enemy_floater.png")
	
	local animationStartIndex = 1
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy1Animations[k] = newAnimation(gImgEnemy1, 64, 64, kEnemyAnimationDelay[k], kEnemy1NumberAnimations[k], animationStartIndex, animationStartIndex + kEnemy1NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy1NumberAnimations[k]
	end

  animationStartIndex = 1
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy2Animations[k] = newAnimation(gImgEnemy2, 64, 64,kEnemyAnimationDelay[k], kEnemy2NumberAnimations[k], animationStartIndex, animationStartIndex + kEnemy2NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy2NumberAnimations[k]
	end

	animationStartIndex = 1
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy3Animations[k] = newAnimation(gImgEnemy3, 64, 64, kEnemyAnimationDelay[k], kEnemy3NumberAnimations[k], animationStartIndex, animationStartIndex + kEnemy3NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy3NumberAnimations[k]
	end

	animationStartIndex = 1
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy4Animations[k] = newAnimation(gImgEnemy4, 64, 64, kEnemyAnimationDelay[k], kEnemy4NumberAnimations[k], animationStartIndex, animationStartIndex + kEnemy4NumberAnimations[k] -1)
		animationStartIndex = animationStartIndex + kEnemy4NumberAnimations[k]
	end
	
end

function EnemyUpdate(dt)
	EnemyGroupUpdate(dt, gEnemiesType1)
	EnemyGroupUpdate(dt, gEnemiesType2)
	EnemyGroupUpdate(dt, gEnemiesType3)
	EnemyGroupUpdate(dt, gEnemiesType4)

	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy1Animations[k]:update(dt)
	end
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy2Animations[k]:update(dt)
	end
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy3Animations[k]:update(dt)
	end
	for k, v in pairs(kEnemyAnimationFrameNumbers) do
		gEnemy4Animations[k]:update(dt)
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
		gEnemy1Animations[gEnemyState]:draw(v.x+gCamAddX, v.y+gCamAddY)
		--love.graphics.draw(gImgEnemy1, v.x+gCamAddX, v.y+gCamAddY )
--		love.graphics.draw(gImgDot, floor(v.x/kTileSize + 0.5)*kTileSize+gCamAddX, floor(v.y/kTileSize + 0.5)*kTileSize+gCamAddY )
--		love.graphics.draw(gImgDot, v.x + kTileSize/2+gCamAddX, v.y + kTileSize/2+gCamAddY )
		--~ love.graphics.draw(gImgDot, floor(v.x/kTileSize + 0.05 * v.dX + 0.5)*kTileSize +gCamAddX, floor(v.y/kTileSize + 0.05 * v.dY + 0.5)*kTileSize +gCamAddY )

	end
	for i,v in pairs(gEnemiesType2) do
		gEnemy2Animations[gEnemyState]:draw(v.x+gCamAddX, v.y+gCamAddY)
	end
	for i,v in pairs(gEnemiesType3) do
		gEnemy3Animations[gEnemyState]:draw(v.x+gCamAddX, v.y+gCamAddY)
	end
	for i,v in pairs(gEnemiesType4) do
		gEnemy4Animations[gEnemyState]:draw(v.x+gCamAddX, v.y+gCamAddY)
	end
end

function CheckEnemyCollision(player)
	local died = CheckEnemyGroupCollision(player, gEnemiesType1)
	died = died or CheckEnemyGroupCollision(player, gEnemiesType2)
	died = died or CheckEnemyGroupCollision(player, gEnemiesType3)
	died = died or CheckEnemyGroupCollision(player, gEnemiesType4)
	return died
end

function CheckEnemyGroupCollision(player, group)
	local died = false
	for i,v in pairs(group) do
		if v.x - kTileSize/2 <= player.x and v.x + kTileSize > player.x and v.y <= player.y and v.y + kTileSize > player.y then
			if v.y + kTileSize/2 >= player.y and player.vy > 0 then
				table.remove(group, i)
				gJumpEnemyKill = true
			else
				died = true	
			end
		end
	end
	return died;
end
