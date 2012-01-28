
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

function GameInit ()

	print("GameInit")
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX,gCamY = screen_w/2,screen_h/2
	
	gImgPlayer		= getCachedPaddedImage("data/player.png")
	gImgMarkTile	= getCachedPaddedImage("data/mark-tile.png")
	gImgDot			= getCachedPaddedImage("data/dot.png")

	TiledMap_Load("data/level01.tmx",nil,nil,gMapGfxPrefix)
	
	for k,v in pairs(gMapLayers) do print("maplayer",type(k),k) end
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

kTileType_DBlock_1 = 8
kTileType_DBlock_2 = 16
kTileType_DBlock_3 = 24
kTileType_DBlock_4 = 32
kTileType_DBlock_5 = 40

function DebugMouseClick (x,y,button) -- button = "l" , "r" , "m"
	local tx,ty = GetTileUnderMouse(x,y)
	local t = TiledMap_GetMapTile(tx,ty,kMapLayer_Main)
	if (t == kTileType_DBlock_1) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_2) end
	if (t == kTileType_DBlock_2) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_3) end
	if (t == kTileType_DBlock_3) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_4) end
	if (t == kTileType_DBlock_4) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kTileType_DBlock_5) end
	if (t == kTileType_DBlock_5) then TiledMap_SetMapTile(tx,ty,kMapLayer_Main,kMapTileTypeEmpty) end
	
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
	
	local x,y = 0,kTileSize*4
	love.graphics.draw(gImgPlayer, x+gCamAddX, y+gCamAddY )
	love.graphics.draw(gImgPlayer, screen_w/2,screen_h/2)
	
	local mtx,mty,mx,my = GetTileUnderMouse()
	love.graphics.draw(gImgMarkTile, mtx*kTileSize+gCamAddX, mty*kTileSize+gCamAddY )
	love.graphics.draw(gImgDot, mx+gCamAddX, my+gCamAddY )
	
	--~ Objects_Draw()
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
	if keyboard[kUp] == 1 or joystickaxes[kUp] == 1 then
		gCamY = gCamY - s
	end
	if keyboard[kDown] == 1 or joystickaxes[kDown] == 1 then
		gCamY = gCamY + s
	end
	if keyboard[kLeft] == 1 or joystickaxes[kLeft] == 1 then 
		gCamX = gCamX - s
	end
	if keyboard[kRight] == 1 or joystickaxes[kRight] == 1 then
		gCamX = gCamX + s
	end
	
	--~ Objects_Step(dt)
end

function GameCleanUp ()
	-- after delete 
end

