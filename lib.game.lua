
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

function GameInit ()

	print("GameInit")
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX,gCamY = screen_w/2,screen_h/2
	
	gImgPlayer		= getCachedPaddedImage("data/player.png")
	gImgMarkTile	= getCachedPaddedImage("data/mark-tile.png")
	gImgDot			= getCachedPaddedImage("data/dot.png")

	TiledMap_Load("data/level01.tmx",nil,nil,gMapGfxPrefix)
end


function GameDraw ()
	gMouseX = love.mouse.getX()
	gMouseY = love.mouse.getY()
	
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
	
	local mx = gMouseX - gCamAddX
	local my = gMouseY - gCamAddY
	local mtx = floor(mx/kTileSize)
	local mty = floor(my/kTileSize)
	love.graphics.draw(gImgMarkTile, mtx*kTileSize+gCamAddX, mty*kTileSize+gCamAddY )
	love.graphics.draw(gImgDot, mx+gCamAddX, my+gCamAddY )
	
	--~ Objects_Draw()
end

function GameStep (dt)
    local s = 500*dt
    if (gKeyPressed.up) then gCamY = gCamY - s end
    if (gKeyPressed.down) then gCamY = gCamY + s end
    if (gKeyPressed.left) then gCamX = gCamX - s end
    if (gKeyPressed.right) then gCamX = gCamX + s end
	
	--~ Objects_Step(dt)
end

function GameCleanUp ()
	-- after delete 
end
