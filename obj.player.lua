
gPlayerX = 0
gPlayerY = 0
gPlayerVX = 0
gPlayerVY = 0
gPlayerGravity = 9.81 * 200
gPlayerOnGroundStopXMult = 0.70
gPlayerJumpVY = -800
gPlayerVXMax = 400
gPlayerVXAccelPerSecond = gPlayerVXMax * 200

gPlayerW = 128
gPlayerH = 128

function PlayerInit ()
	gImgPlayer		= getCachedPaddedImage("data/player2.png")
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX = screen_w/2
	gCamY = screen_h/2 + 0.5*kTileSize
	
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


-- local l,t,r,b = GetPlayerBBox()
function GetPlayerBBox () return gPlayerX,gPlayerY,gPlayerX+gPlayerW,gPlayerY+gPlayerH end

-- local minx,maxx,miny,maxy = GetPlayerPosLimits()
function GetPlayerPosLimits ()
	local minx,maxx,miny,maxy
	local l,t,r,b = GetPlayerBBox()
	-- vertical : 
	--~ local tx1 = 
	
	maxy = kTileSize * 8
	return minx,maxx,miny,maxy
end

function PlayerUpdate(dt)
    local s = 500*dt
	
	local bPressed_Left	= 0
	local bPressed_Right	= 0
	local bPressed_Up		= 0
	local bPressed_Down	= 0
	if keyboard[kUp] == 1 or joystickaxes[kUp] == 1 then
		bPressed_Up = true
	else
		bPressed_Up = false
	end
	if keyboard[kDown] == 1 or joystickaxes[kDown] == 1 then
		bPressed_Down = true
	else
		bPressed_Down = false
	end
	if keyboard[kLeft] == 1 or joystickaxes[kLeft] == 1 then 
		bPressed_Left = true
	else
		bPressed_Left = false
	end
	if keyboard[kRight] == 1 or joystickaxes[kRight] == 1 then
		bPressed_Right = true
	else
		bPressed_Right = false
	end
	
    --~ if (bPressed_Up) then gCamY = gCamY - s end
    --~ if (bPressed_Down) then gCamY = gCamY + s end
    --~ if (bPressed_Left) then gCamX = gCamX - s end
    --~ if (bPressed_Right) then gCamX = gCamX + s end
	
    --~ if (bPressed_Up) then gPlayerY = gPlayerY - s end
    --~ if (bPressed_Down) then gPlayerY = gPlayerY + s end
    --~ if (bPressed_Left) then gPlayerX = gPlayerX - s end
    --~ if (bPressed_Right) then gPlayerX = gPlayerX + s end
	
	
	
	
	local bOnGround = false
	
	
	local minx,maxx,miny,maxy = GetPlayerPosLimits()

	if (maxy) then 
		if (gPlayerY >= maxy) then
			gPlayerY = maxy
			bOnGround = true
			if (gPlayerVY > 0) then gPlayerVY = 0 end
		end
	end
	if (miny and gPlayerY < miny) then gPlayerY = miny if (gPlayerVY < 0) then gPlayerVY = 0 end end
	if (minx and gPlayerX < minx) then gPlayerX = minx if (gPlayerVX < 0) then gPlayerVX = 0 end end
	if (maxx and gPlayerX > maxx) then gPlayerX = maxx if (gPlayerVX > 0) then gPlayerVX = 0 end end
	
	
	if (bPressed_Up and bOnGround) then gPlayerVY = gPlayerJumpVY end
	local vxadd = 0
	if (bPressed_Left ) then vxadd = vxadd + -gPlayerVXAccelPerSecond end
	if (bPressed_Right) then vxadd = vxadd +  gPlayerVXAccelPerSecond end
	
	-- xspeed accell or friction
	if (vxadd == 0) then 
		gPlayerVX = gPlayerVX*gPlayerOnGroundStopXMult
	else
		gPlayerVX = gPlayerVX + vxadd*dt
	end
	
	-- limit x speed
	gPlayerVX = max(-gPlayerVXMax,min(gPlayerVXMax,gPlayerVX))
	
	
	gPlayerX = gPlayerX + gPlayerVX * dt 
	gPlayerY = gPlayerY + gPlayerVY * dt 
	if (not bOnGround) then gPlayerVY = gPlayerVY + gPlayerGravity*dt end
	
	
	
	-- move cam to player
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	local f = 0.05
	local fi = 1-f
	
	gCamX = max(screen_w/2,fi * gCamX + f * (gPlayerX + 0.2*screen_w))
end
	
