
gEnemiesType1 = { }
gEnemiesType2 = { }
gEnemiesType3 = { }
gEnemiesType4 = { }

kWalkSpeed = 1.0
kWalkSpeedDiag = 0,707 * kWalkSpeed

function EnemiesSpawnAtStart()
	gEnemiesType1 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type1)
	gEnemiesType2 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type2)
	gEnemiesType3 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type3)
	gEnemiesType4 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Enemy_Type4)
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type1)
	for i,v in pairs(temp) do
		gEnemiesType1[#gEnemiesType1 + 1] = v
	end
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type2)
	for i,v in pairs(temp) do
		gEnemiesType2[#gEnemiesType2 + 1] = v
	end
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type3)
	for i,v in pairs(temp) do
		gEnemiesType3[#gEnemiesType3 + 1] = v
	end
	temp = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type4)
	for i,v in pairs(temp) do
		gEnemiesType4[#gEnemiesType4 + 1] = v
	end
	
	for i,v in pairs(gEnemiesType1) do
		gEnemiesType1[i].x = gEnemiesType1[i].x *kTileSize;
		gEnemiesType1[i].y = gEnemiesType1[i].y *kTileSize;
		gEnemiesType1[i].walkDir = 1;
		gEnemiesType1[i].dX = 0;
		gEnemiesType1[i].dY = 0;
	end
	for i,v in pairs(gEnemiesType2) do
		gEnemiesType2[i].x = gEnemiesType2[i].x *kTileSize;
		gEnemiesType2[i].y = gEnemiesType2[i].y *kTileSize;
		gEnemiesType2[i].walkDir = 1;
		gEnemiesType2[i].dX = 0;
		gEnemiesType2[i].dY = 0;
	end
	for i,v in pairs(gEnemiesType3) do
		gEnemiesType3[i].x = gEnemiesType3[i].x *kTileSize;
		gEnemiesType3[i].y = gEnemiesType3[i].y *kTileSize;
		gEnemiesType3[i].walkDir = 1;
		gEnemiesType3[i].dX = 0;
		gEnemiesType3[i].dY = 0;
	end
	for i,v in pairs(gEnemiesType4) do
		gEnemiesType4[i].x = gEnemiesType4[i].x *kTileSize;
		gEnemiesType4[i].y = gEnemiesType4[i].y *kTileSize;
		gEnemiesType4[i].walkDir = 1;
		gEnemiesType4[i].dX = 0;
		gEnemiesType4[i].dY = 0;
	end
end

function EnemyInit()
	gImgEnemy1		= getCachedPaddedImage("data/enemy.png")
	gImgEnemy2		= getCachedPaddedImage("data/enemy.png")
	gImgEnemy3		= getCachedPaddedImage("data/enemy.png")
	gImgEnemy4		= getCachedPaddedImage("data/enemy.png")
end

function EnemyUpdate(dt)
	for i,v in pairs(gEnemiesType1) do
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
		love.graphics.draw(gImgEnemy1, v.x+gCamAddX, v.y+gCamAddY )
--		love.graphics.draw(gImgDot, floor(v.x/kTileSize + 0.5)*kTileSize+gCamAddX, floor(v.y/kTileSize + 0.5)*kTileSize+gCamAddY )
--		love.graphics.draw(gImgDot, v.x + kTileSize/2+gCamAddX, v.y + kTileSize/2+gCamAddY )
		love.graphics.draw(gImgDot, floor(v.x/kTileSize + 0.05 * v.dX + 0.5)*kTileSize +gCamAddX, floor(v.y/kTileSize + 0.05 * v.dY + 0.5)*kTileSize +gCamAddY )

	end
	for i,v in pairs(gEnemiesType2) do
		love.graphics.draw(gImgEnemy2, v.x+gCamAddX, v.y+gCamAddY )
	end
	for i,v in pairs(gEnemiesType3) do
		love.graphics.draw(gImgEnemy3, v.x+gCamAddX, v.y+gCamAddY )
	end
	for i,v in pairs(gEnemiesType4) do
		love.graphics.draw(gImgEnemy4, v.x+gCamAddX, v.y+gCamAddY )
	end
end

