
Objects_InitLayerOrder({
	"asdasd",
})

gMapGfxPrefix = "data/"

--~ kTileSize = 64 -- see lib.mapload.lua

function GameInit ()

	print("GameInit")
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX,gCamY = screen_w/2,screen_h/2
	
	gImgPlayer = getCachedPaddedImage("data/player.png")

	TiledMap_Load("data/level01.tmx",nil,nil,gMapGfxPrefix)
end


function GameDraw ()
	--~ gMouseX = love.mouse.getX()
	--~ gMouseY = love.mouse.getY()
	
	local camx,camy = floor(gCamX),floor(gCamY)
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    
	gCamAddX = -camx + screen_w/2
	gCamAddY = -camy + screen_h/2
	
	
	love.graphics.setColor(255,255,255,255)
    love.graphics.setBackgroundColor(0xb7,0xd3,0xd4)
    TiledMap_DrawNearCam(gCamX,gCamY)
	
	local x,y = 0,kTileSize*4
	love.graphics.draw(gImgPlayer, x+gCamAddX, y+gCamAddY )
	love.graphics.draw(gImgPlayer, screen_w/2,screen_h/2)
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
