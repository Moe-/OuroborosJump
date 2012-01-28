
Objects_InitLayerOrder({
	"asdasd",
})

gMapGfxPrefix = "data/"

floor = math.floor
ceil = math.ceil
abs = math.abs
max = math.max
min = math.min

--~ kTileSize = 64 -- see lib.mapload.lua
kMapLayer_Main = 1


kTileType_DBlock_1 = 8
kTileType_DBlock_2 = 16
kTileType_DBlock_3 = 24
kTileType_DBlock_4 = 32
kTileType_DBlock_5 = 40
kTileType_Start = 7

function GameDamageBlock (tx,ty) 
	local t = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
	if (t == kTileType_DBlock_1) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_2) end
	if (t == kTileType_DBlock_2) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_3) end
	if (t == kTileType_DBlock_3) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_4) end
	if (t == kTileType_DBlock_4) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_5) end
	if (t == kTileType_DBlock_5) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kMapTileTypeEmpty) end
end





function GameInit ()

	print("GameInit")
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX,gCamY = screen_w/2,screen_h/2
	
	gImgMarkTile	= getCachedPaddedImage("data/mark-tile.png")
	gImgDot			= getCachedPaddedImage("data/dot.png")

	gMapPath = "data/level01.tmx"
	TiledMap_Load(gMapPath,nil,nil,gMapGfxPrefix)
	
	for k,v in pairs(gMapLayers) do print("maplayer",type(k),k) end
	
	PlayerInit()
	PlayerSpawnAtStart()
	
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
	
	PlayerDraw()
	
	local mtx,mty,mx,my = GetTileUnderMouse()
	love.graphics.draw(gImgMarkTile, mtx*kTileSize+gCamAddX, mty*kTileSize+gCamAddY )
	love.graphics.draw(gImgDot, mx+gCamAddX, my+gCamAddY )
	
	Objects_Draw()
end

function GameStep (dt)
	PlayerUpdate(dt)
	Objects_Step(dt)
end

function GameCleanUp ()
	-- after delete 
end
