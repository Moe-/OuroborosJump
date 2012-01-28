
gEnemiesType1 = { }
gEnemiesType2 = { }
gEnemiesType3 = { }
gEnemiesType4 = { }

function EnemiesSpawnAtStart()
	gEnemiesType1 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type1)
	gEnemiesType2 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type2)
	gEnemiesType3 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type3)
	gEnemiesType4 = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Enemy_Type4)
	
	for i,v in pairs(gEnemiesType1) do
		gEnemiesType1[i].x = gEnemiesType1[i].x *kTileSize;
		gEnemiesType1[i].y = gEnemiesType1[i].y *kTileSize;
	end
	for i,v in pairs(gEnemiesType2) do
		gEnemiesType2[i].x = gEnemiesType2[i].x *kTileSize;
		gEnemiesType2[i].y = gEnemiesType2[i].y *kTileSize;
	end
	for i,v in pairs(gEnemiesType3) do
		gEnemiesType3[i].x = gEnemiesType3[i].x *kTileSize;
		gEnemiesType3[i].y = gEnemiesType3[i].y *kTileSize;
	end
	for i,v in pairs(gEnemiesType4) do
		gEnemiesType4[i].x = gEnemiesType4[i].x *kTileSize;
		gEnemiesType4[i].y = gEnemiesType4[i].y *kTileSize;
	end
end

function EnemyInit()
	gImgEnemy1		= getCachedPaddedImage("data/enemy.png")
	gImgEnemy2		= getCachedPaddedImage("data/enemy.png")
	gImgEnemy3		= getCachedPaddedImage("data/enemy.png")
	gImgEnemy4		= getCachedPaddedImage("data/enemy.png")
end

function EnemyUpdate(dt)
	--TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
end

function EnemyDraw()
	for i,v in pairs(gEnemiesType1) do
		love.graphics.draw(gImgEnemy1, v.x+gCamAddX, v.y+gCamAddY )
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

