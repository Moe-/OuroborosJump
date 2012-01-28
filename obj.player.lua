
gPlayerX = 0
gPlayerY = 0


function PlayerInit ()
	gImgPlayer		= getCachedPaddedImage("data/player.png")
end

function PlayerSpawnAtStart ()
	local startpos = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Main,kTileType_Start)
	local o = startpos[1]
	print("startpos",o and o.x,o and o.y)
	assert(o,"startpos not found on "..tostring(gMapPath))
	gPlayerX = 0
	gPlayerY = 0
	if (o) then gPlayerX = o.x * kTileSize  gPlayerY = o.y * kTileSize - kTileSize end
end

function PlayerDraw ()
	local x,y = 0,kTileSize*4
	love.graphics.draw(gImgPlayer, gPlayerX+gCamAddX, gPlayerY+gCamAddY )
	--~ love.graphics.draw(gImgPlayer, x+gCamAddX, y+gCamAddY )
	--~ love.graphics.draw(gImgPlayer, screen_w/2,screen_h/2)
end


function PlayerUpdate(dt)
    local s = 500*dt
    --~ if (gKeyPressed.up) then gCamY = gCamY - s end
    --~ if (gKeyPressed.down) then gCamY = gCamY + s end
    --~ if (gKeyPressed.left) then gCamX = gCamX - s end
    --~ if (gKeyPressed.right) then gCamX = gCamX + s end
	
    if (gKeyPressed.up) then gPlayerY = gPlayerY - s end
    if (gKeyPressed.down) then gPlayerY = gPlayerY + s end
    if (gKeyPressed.left) then gPlayerX = gPlayerX - s end
    if (gKeyPressed.right) then gPlayerX = gPlayerX + s end
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	local f = 0.05
	local fi = 1-f
	gCamX = max(screen_w/2,fi * gCamX + f * (gPlayerX + 0.2*screen_w))
end
	