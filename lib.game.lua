
Objects_InitLayerOrder({
	"asdasd",
})

gMapGfxPrefix = "data/"


function GameInit ()

	print("GameInit")
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX,gCamY = screen_w/2,screen_h/2
	
	--~ gImgLives 			= getCachedPaddedImage("Resources/lives.png")

	TiledMap_Load("data/level01.tmx",nil,nil,gMapGfxPrefix)
end


function GameDraw ()
	--~ gMouseX = love.mouse.getX()
	--~ gMouseY = love.mouse.getY()
	
	love.graphics.setColor(255,255,255,255)
    love.graphics.setBackgroundColor(0x80,0x80,0x80)
    TiledMap_DrawNearCam(gCamX,gCamY)
	
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
