
Objects_InitLayerOrder({
	"asdasd",
})

gMapGfxPrefix = "data/"

gMapPath = "data/level01.tmx"
gMapPath = "data/level02.tmx"

floor = math.floor
ceil = math.ceil
abs = math.abs
max = math.max
min = math.min

--~ kTileSize = 64 -- see lib.mapload.lua

gCamAddX = 0
gCamAddY = 0


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


function GameDamageBlock (tx,ty) 
	local t = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
	if (t == kTileType_DBlock_1) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_2) end
	if (t == kTileType_DBlock_2) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_3) end
	if (t == kTileType_DBlock_3) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_4) end
	if (t == kTileType_DBlock_4) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_5) end
	if (t == kTileType_DBlock_5) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kMapTileTypeEmpty) end
end

gMapIsBlockSolid = {}
gMapIsBlockSolid[kTileType_DBlock_1] = true
gMapIsBlockSolid[kTileType_DBlock_2] = true
gMapIsBlockSolid[kTileType_DBlock_3] = true
gMapIsBlockSolid[kTileType_DBlock_4] = true
gMapIsBlockSolid[kTileType_DBlock_5] = true

function IsMapBlockSolid (tx,ty) return gMapIsBlockSolid[TiledMap_GetMapTile(tx,ty,kMapLayer_Main)] end



function GameInit ()
	for row=0,8 do for x=1,3 do gMapIsBlockSolid[row*8+x] = true end end
	-- solid block types : 1,2,3
	-- solid block types : 9,10,11
	-- solid block types : 57,58,59



	print("GameInit")
		
	gImgMarkTile		= getCachedPaddedImage("data/mark-tile.png")
	gImgMarkTile_black	= getCachedPaddedImage("data/mark-tile-black.png")
	gImgMarkTile_white	= getCachedPaddedImage("data/mark-tile-white.png")
	gImgMarkTile_green	= getCachedPaddedImage("data/mark-tile-green.png")
	gImgMarkTile_red	= getCachedPaddedImage("data/mark-tile-red.png")
	gImgMarkTile_yellow	= getCachedPaddedImage("data/mark-tile-yellow.png")
	gImgMarkTile_blue	= getCachedPaddedImage("data/mark-tile-blue.png")
	
	gImgDot				= getCachedPaddedImage("data/dot.png")

	TiledMap_Load(gMapPath,nil,nil,gMapGfxPrefix)
	local lname = "meta"	local lid = TiledMap_GetLayerZByName(lname) assert(lid,"missing layer: '"..tostring(lname).."'") kMapLayer_Meta = lid
	local lname = "main"	local lid = TiledMap_GetLayerZByName(lname) assert(lid,"missing layer: '"..tostring(lname).."'") kMapLayer_Main = lid
	local lname = "ai"		local lid = TiledMap_GetLayerZByName(lname) assert(lid,"missing layer: '"..tostring(lname).."'") kMapLayer_AI = lid
	
	gMapUsedW = TiledMap_GetMapWUsed()
	print("gMapUsedW",gMapUsedW)
	
	for k,v in pairs(gMapLayers) do print("maplayer",type(k),k) end
	
	PlayerInit()
	EnemyInit()
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
	local t = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
	GameDamageBlock(tx,ty)
	print("DebugMouseClick",tx,ty,button,t)
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
    love.graphics.setBackgroundColor(0xb7,0xd3,0xd4)
    TiledMap_DrawNearCam(gCamX,gCamY)
	
	local mapw = gMapUsedW*kTileSize
	if (gCamX < 0.5*mapw) then 
		TiledMap_DrawNearCam(gCamX+mapw,gCamY)
	else 
		-- draw 2nd level loop
		TiledMap_DrawNearCam(gCamX-mapw,gCamY)
	end
	
	EnemyDraw()
	PlayerDraw()
	
	local mtx,mty,mx,my = GetTileUnderMouse()
	love.graphics.draw(IsMapBlockSolid(mtx,mty) and gImgMarkTile_green or gImgMarkTile, mtx*kTileSize+gCamAddX, mty*kTileSize+gCamAddY )
	love.graphics.draw(gImgDot, mx+gCamAddX, my+gCamAddY )
	
	Objects_Draw()
	CollisionDrawDebug_Step()
	CollisionDebugDraw()
end

function GameStep (dt)
  local s = 500*dt
	joystick0 = 0
	if(love.joystick.getNumJoysticks( ) > 0) then
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
	Objects_Step(dt)
	CollisionDebugStep()
	
	local mapw = gMapUsedW*kTileSize
	if (gPlayer.x > mapw) then 
		gPlayer.x = gPlayer.x - mapw
		gCamX = gCamX - mapw
	elseif (gPlayer.x < 0) then 
		gPlayer.x = gPlayer.x + mapw
		gCamX = gCamX + mapw
	end
end

function GameCleanUp ()
	-- after delete 
end

