
Objects_InitLayerOrder({
	"asdasd",
})

gMapGfxPrefix = "data/"

gFirstLevelStarted = 0
kFirstLevelStartCount = 4
kPointsPlayer = 0

function MyStartLevel ()
	gMapPath = "data/level" .. gCurrentLevel .. ".tmx"
end


gMapMetaInvis = true

floor = math.floor
ceil = math.ceil
abs = math.abs
max = math.max
min = math.min

--~ kTileSize = 64 -- see lib.mapload.lua


kTileType_DBlock_1 = 8
kTileType_DBlock_2 = 16
kTileType_DBlock_3 = 24
kTileType_DBlock_4 = 32
kTileType_DBlock_5 = 40
kTileType_Start = 7
kTileType_Enemy_Type1 = 6
kTileType_Enemy_Type2 = 14
kTileType_Enemy_Type3 = 22
kTileType_Enemy_Type4 = 30
kTileType_Coin = 12 * 8 + 7

gDestroyBlockSequence = {}
gDestroyBlockSequence[kTileType_DBlock_1] = kTileType_DBlock_2
gDestroyBlockSequence[kTileType_DBlock_2] = kTileType_DBlock_3
gDestroyBlockSequence[kTileType_DBlock_3] = kTileType_DBlock_4
gDestroyBlockSequence[kTileType_DBlock_4] = kTileType_DBlock_5
gDestroyBlockSequence[kTileType_DBlock_5] = kMapTileTypeEmpty
 
--~ print("gDestroyBlockSequence 5:",kTileType_DBlock_5,kMapTileTypeEmpty)
 

gTileIsDeadly = {}
gTileIsDeadly[4] = true -- spike
gTileIsDeadly[5] = true -- spike
gTileIsDeadly[12] = true -- spike
gTileIsDeadly[13] = true -- spike
gTileIsDeadly[61] = true -- water


 
function CheatShowMapMetaData ()
	gTileMap_LayerInvisByName = {}
end


function IsTileDeadly			(tx,ty)
	return	gTileIsDeadly[TiledMap_GetMapTile(tx,ty,kMapLayer_Main)] or 
			gTileIsDeadly[TiledMap_GetMapTile(tx,ty,kMapLayer_Meta)] or 
			gTileIsDeadly[TiledMap_GetMapTile(tx,ty,kMapLayer_AI)]
end
function IsBlockDestructible	(tx,ty) return gDestroyBlockSequence[TiledMap_GetMapTile(tx,ty,kMapLayer_Main)] end


function GameDamageBlock (tx,ty) 
	local t = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
	local t2 = gDestroyBlockSequence[t]
	--~ print("GameDamageBlock",tx,ty,t,t2)
	if (t2) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,t2) end
end

gMapIsBlockSolid = {}
gMapIsBlockSolid[kTileType_DBlock_1] = true
gMapIsBlockSolid[kTileType_DBlock_2] = true
gMapIsBlockSolid[kTileType_DBlock_3] = true
gMapIsBlockSolid[kTileType_DBlock_4] = true
gMapIsBlockSolid[kTileType_DBlock_5] = true

function IsMapBlockSolid (tx,ty) return gMapIsBlockSolid[TiledMap_GetMapTile(tx,ty,kMapLayer_Main)] end



function GameInit ()
	gCamAddX = 0
	gCamAddY = 0
	gMinCamX = 0
	gRunCount = 0

	for row=0,20 do for x=1,3 do gMapIsBlockSolid[row*8+x] = true end end
	
	gMapIsBlockSolid[9] = nil	-- gras invis top row 1
	gMapIsBlockSolid[10] = nil	-- gras invis top row 1
	gMapIsBlockSolid[11] = nil	-- gras invis top row 1
	
	gMapIsBlockSolid[41] = nil	-- gras invis top row 1
	gMapIsBlockSolid[42] = nil	-- gras invis top row 2
	gMapIsBlockSolid[43] = nil	-- gras invis top row 3
	
	
	gMapIsBlockSolid[57] = nil	-- small stone bottom deco
	
	
	gMapIsBlockSolid[59+8] = nil	-- small stone bottom deco
	
	-- solid block types : 1,2,3
	-- solid block types : 9,10,11
	-- solid block types : 57,58,59

	gMyFont = love.graphics.newFont( "data/Ascension_0.ttf", 48 ) or love.graphics.newFont( 48 )

	print("GameInit")
		
	gImgGui				= getCachedPaddedImage("data/gui.png")
	gImgMarkTile		= getCachedPaddedImage("data/mark-tile.png")
	gImgMarkTile_black	= getCachedPaddedImage("data/mark-tile-black.png")
	gImgMarkTile_white	= getCachedPaddedImage("data/mark-tile-white.png")
	gImgMarkTile_green	= getCachedPaddedImage("data/mark-tile-green.png")
	gImgMarkTile_red	= getCachedPaddedImage("data/mark-tile-red.png")
	gImgMarkTile_yellow	= getCachedPaddedImage("data/mark-tile-yellow.png")
	gImgMarkTile_blue	= getCachedPaddedImage("data/mark-tile-blue.png")
	gImgBackgroundColour		= getCachedPaddedImage("data/Himmel.jpg")
	
	gImgDot				= getCachedPaddedImage("data/dot.png")
	
	MyStartLevel()
	TiledMap_Load(gMapPath,nil,nil,gMapGfxPrefix)
	local lname = "meta"	local lid = TiledMap_GetLayerZByName(lname) assert(lid,"missing layer: '"..tostring(lname).."'") kMapLayer_Meta = lid
	local lname = "main"	local lid = TiledMap_GetLayerZByName(lname) assert(lid,"missing layer: '"..tostring(lname).."'") kMapLayer_Main = lid
	local lname = "ai"		local lid = TiledMap_GetLayerZByName(lname) assert(lid,"missing layer: '"..tostring(lname).."'") kMapLayer_AI = lid
	local lname = "player"	local lid = TiledMap_GetLayerZByName(lname) kMapLayer_Player = lid -- not fatal if missing
	
	gMapUsedW = TiledMap_GetMapWUsed()
	print("gMapUsedW",gMapUsedW)
	
	for k,v in pairs(gMapLayers) do print("maplayer",type(k),k) end
	
	if (gMapMetaInvis) then gTileMap_LayerInvisByName["meta"] = true end
	if (gMapMetaInvis) then gTileMap_LayerInvisByName["ai"] = true end

	Background_Init()
	
	PlayerInit()
	EnemyInit()
	CoinInit()
	PlayerSpawnAtStart()
	EnemiesSpawnAtStart()
	
end


function UpdateMousePos ()
	gMouseX = love.mouse.getX()
	gMouseY = love.mouse.getY()
end

function GetTileUnderMouse (x,y)
	UpdateMousePos()
	local mx = (x or gMouseX) - gCamAddX
	local my = (y or gMouseY) - gCamAddY
	local mtx = floor(mx/kTileSize)
	local mty = floor(my/kTileSize)
	return mtx,mty,mx,my
end

function DebugMouseClick (x,y,button) -- button = "l" , "r" , "m"
	local tx,ty = GetTileUnderMouse(x,y)
	local t1 = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
	local t2 = TiledMap_GetMapTile(tx,ty,kMapLayer_Meta)
	local t3 = TiledMap_GetMapTile(tx,ty,kMapLayer_AI)
	GameDamageBlock(tx,ty)
	print("DebugMouseClick x,y="..tx..","..ty.." main="..tostring(t1).." meta="..tostring(t2).." ai="..tostring(t3))
	
	
	
	
end

function GameDraw ()
	UpdateMousePos()
	
	local camx,camy = floor(gCamX),floor(gCamY)
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    
	gCamAddX = -camx + screen_w/2
	gCamAddY = -camy + screen_h/2
	
	asd = 1123
	
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(gImgBackgroundColour, 0, 0)
	Background_Draw()
	
	CoinDraw()
	EnemyDraw()
	
	
	if (not kMapLayer_Player) then PlayerDraw() end
	
	
	
    TiledMap_DrawNearCam(gCamX,gCamY,function (z,layer) if (z == kMapLayer_Player) then PlayerDraw() end end)
	local mapw = gMapUsedW*kTileSize
	if (gCamX < 0.5*mapw) then 
		TiledMap_DrawNearCam(gCamX+mapw,gCamY)
	else 
		-- draw 2nd level loop
		TiledMap_DrawNearCam(gCamX-mapw,gCamY)
	end
	
	
	
	local mtx,mty,mx,my = GetTileUnderMouse()
	--~ love.graphics.draw(IsMapBlockSolid(mtx,mty) and gImgMarkTile_green or gImgMarkTile, mtx*kTileSize+gCamAddX, mty*kTileSize+gCamAddY )
	--~ love.graphics.draw(gImgDot, mx+gCamAddX, my+gCamAddY )
	
	Objects_Draw()
	CollisionDrawDebug_Step()
	CollisionDebugDraw()
	
	love.graphics.draw(gImgGui, 0, screen_h-128+32)
	
	
	local ptxt = TausenderTrenner(max(0,floor(kPointsPlayer)))
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(gMyFont)
	local y0 = 630+32
	love.graphics.print("   " .. gRunCount, 30, y0)
	love.graphics.print("    " .. ptxt, 500, y0) -- points
	love.graphics.print("    " .. floor(gCoinsCollected), 1000, y0)
	love.graphics.setColor(255, 0, 0)
	love.graphics.print("   " .. gRunCount, 26, y0)
	love.graphics.print("    " .. ptxt, 496, y0) -- points
	love.graphics.print("    " .. floor(gCoinsCollected), 996, y0)

	love.graphics.setColor(255, 255, 255)
end

function TausenderTrenner (v)
	local txt = tostring(abs(v))
	local len = #txt
	local res = ""
	for i=1,len do 
		local cpos = len-i+1
		local c = string.sub(txt,cpos,cpos)
		res = c .. res
		if ((i % 3) == 0 and i < len) then res = "," .. res end
	end
	
	
	return (v<0) and ("-"..res) or res
end

function GameNotifyNextMapCycle()
	Background_NotifyNextMapCycle()
	gFirstLevelStarted = gFirstLevelStarted + 0.5
	
	--if (gFirstLevelStarted >= kFirstLevelStartCount and gMapPath ~= kMapPath_Level02) then 
		-- restart game in next level 
		--cScreenGame:Start()
	--end
end

gScoreLastX = 0
function GameStep (dt)
	dt = min(0.1, dt)
	Background_Step(dt)
	
  local s = 500*dt
	joystick0 = love.joystick.getNumJoysticks( )
	if(joystick0 > 0) then
		-- leftRightAxis -1 left +1 right
		-- up -1 down 1
		leftRightAxis, upDownAxis = love.joystick.getAxes( joystick0 )
		if (upDownAxis > joysticksensitivity) then
			joystickaxes[kDown] = 1
			joystickaxes[kUp] = 0
		elseif (upDownAxis < -joysticksensitivity) then
			joystickaxes[kDown] = 0
			joystickaxes[kUp] = 1
		else 
			joystickaxes[kDown] = 0
			joystickaxes[kUp] = 0
		end
		if (leftRightAxis > joysticksensitivity) then
			joystickaxes[kRight] = 1
			joystickaxes[kLeft] = 0
		elseif (leftRightAxis < -joysticksensitivity) then
			joystickaxes[kRight] = 0
			joystickaxes[kLeft] = 1
		else 
			joystickaxes[kRight] = 0
			joystickaxes[kLeft] = 0
		end	
	end
--	if keyboard[kUp] == 1 or joystickaxes[kUp] == 1 then
--		gCamY = gCamY - s
--	end
--	if keyboard[kDown] == 1 or joystickaxes[kDown] == 1 then
--		gCamY = gCamY + s
--	end
--	if keyboard[kLeft] == 1 or joystickaxes[kLeft] == 1 then 
--		gCamX = gCamX - s
--	end
--	if keyboard[kRight] == 1 or joystickaxes[kRight] == 1 then
--		gCamX = gCamX + s
--	end
	
	PlayerUpdate(dt)
	EnemyUpdate(dt)
	CoinUpdate(dt)
	Objects_Step(dt)
	CollisionDebugStep()
	
	local mapw = gMapUsedW*kTileSize
	if abs(gPlayer.x - gScoreLastX) < love.graphics.getWidth() then
		kPointsPlayer = kPointsPlayer + (gPlayer.x - gScoreLastX)
	end
	gScoreLastX = gPlayer.x
	if (gPlayer.x > mapw) then 
		if gMinCamX > 0 then
			gRunCount = gRunCount + 1
			EnemiesRespawn(gRunCount%kSpawnDistance)
			RespawnCoins()
			love.audio.play(gCheerSound)
		end	
		gPlayer.x = gPlayer.x - mapw
		gCamX = gCamX - mapw
		gMinCamX = gCamX
		GameNotifyNextMapCycle()
	elseif (gPlayer.x < 0) then 
		gPlayer.x = gPlayer.x + mapw
		gCamX = gCamX + mapw
		gMinCamX = 0
	end
end

function GameCleanUp ()
	-- after delete 
end

