
gPlayer = {x=0,y=0,vx=0,vy=0,r=55,drawx=-64,drawy=-64}
gPlayerGravity = 9.81 * 200
gPlayerOnGroundStopXMult = 0.70
gPlayerJumpVY = -800
gPlayer.vxMax = 400
gPlayer.vxAccelPerSecond = gPlayer.vxMax * 200


gPlayerAnimationIdleRight = nil
gPlayerAnimationIdleLeft = nil
gPlayerAnimationMoveRight = nil
gPlayerAnimationMoveLeft = nil

kPlayerStateMoveRight = 0
kPlayerStateMoveLeft = 1
kPlayerStateIdleRight = 2
kPlayerStateIdleLeft = 3

gPlayerState = kPlayerStateIdleRight

function PlayerInit ()
	gImgPlayer		= getCachedPaddedImage("data/player_tileset.png")
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	gCamX = screen_w/2
	gCamY = screen_h/2 + 0.5*kTileSize

	gPlayerAnimationIdleRight = newAnimation(gImgPlayer, 128, 128, 0.06, 4*32, 1, 1*32)
	gPlayerAnimationIdleLeft = newAnimation(gImgPlayer, 128, 128, 0.06, 4*32, 1*32+1, 2*32)
	gPlayerAnimationMoveRight = newAnimation(gImgPlayer, 128, 128, 0.02, 4*32, 2*32+1, 3*32)
	gPlayerAnimationMoveLeft = newAnimation(gImgPlayer, 128, 128, 0.02, 4*32, 3*32+1, 4*32)
end

function PlayerSpawnAtStart ()
	local startpos = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta,kTileType_Start)
	local o = startpos[1]
	print("startpos",o and o.x,o and o.y)
	assert(o,"startpos not found on "..tostring(gMapPath))
	gPlayer.x = 0
	gPlayer.y = 0
	if (o) then gPlayer.x = o.x * kTileSize  gPlayer.y = o.y * kTileSize - kTileSize end
end

function PlayerDraw ()
	local x,y = 0,kTileSize*4

	--~ love.graphics.draw(gImgPlayer, gPlayer.x+gCamAddX, gPlayer.y+gCamAddY )

	--~ love.graphics.draw(gImgPlayer, x+gCamAddX, y+gCamAddY )
	--~ love.graphics.draw(gImgPlayer, screen_w/2,screen_h/2)
	
	-- draw idle animation
  if (gPlayerState == kPlayerStateIdleLeft) then
		gPlayerAnimationIdleLeft:draw(gPlayer.x+gPlayer.drawx+gCamAddX, gPlayer.y+gPlayer.drawy+gCamAddY, 0, 1, 1, 0, 0)
	elseif (gPlayerState == kPlayerStateIdleRight) then
		gPlayerAnimationIdleRight:draw(gPlayer.x+gPlayer.drawx+gCamAddX, gPlayer.y+gPlayer.drawy+gCamAddY, 0, 1, 1, 0, 0)
	-- draw move animation
	elseif (gPlayerState == kPlayerStateMoveLeft) then
		gPlayerAnimationMoveLeft:draw(gPlayer.x+gPlayer.drawx+gCamAddX, gPlayer.y+gPlayer.drawy+gCamAddY, 0, 1, 1, 0, 0)
	elseif (gPlayerState == kPlayerStateMoveRight) then
		gPlayerAnimationMoveRight:draw(gPlayer.x+gPlayer.drawx+gCamAddX, gPlayer.y+gPlayer.drawy+gCamAddY, 0, 1, 1, 0, 0)
	end
	
	--~ local l,t,r,b = GetPlayerBBox()
	--~ local x,y = l,t	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	--~ local x,y = l,b	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	--~ local x,y = r,t	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	--~ local x,y = r,b	love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	
	--~ local mx = 0.5*(l+r)
	--~ local my = 0.5*(t+b)
	
end

function DrawDebugBlock (img,tx,ty) 
	love.graphics.draw(img, tx*kTileSize+gCamAddX, ty*kTileSize+gCamAddY )
end

-- local l,t,r,b = GetPlayerBBox()
function GetPlayerBBox () local x,y,r = gPlayer.x,gPlayer.y,gPlayer.r return x-r,y-r,x+r,y+r end


function PlayerUpdate(dt)
  local s = 500*dt
	
	local bPressed_Left	= 0
	local bPressed_Right	= 0
	local bPressed_Up		= 0
	local bPressed_Down	= 0
	if keyboard[kUp] == 1 or joystickbuttons[kA] == 1 then
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
		gPlayerState = kPlayerStateMoveLeft
	else
		bPressed_Left = false
	end
	if keyboard[kRight] == 1 or joystickaxes[kRight] == 1 then
		bPressed_Right = true
		gPlayerState = kPlayerStateMoveRight
	else
		bPressed_Right = false
	end

	if ((not bPressed_Left) and (not bPressed_Right) and (not bPressed_Up) and (not bPressed_Down)) then
		if (gPlayerState == kPlayerStateIdleLeft or gPlayerState == kPlayerStateMoveLeft) then
			gPlayerState = kPlayerStateIdleLeft
		else
			gPlayerState = kPlayerStateIdleRight
		end
	end

	-- update player animation depending on state of player
	if (gPlayerState == kPlayerStateIdleLeft) then
		gPlayerAnimationIdleLeft:update(dt)
	elseif (gPlayerState == kPlayerStateIdleRight) then
		gPlayerAnimationIdleRight:update(dt)
	elseif (gPlayerState == kPlayerStateMoveLeft) then
		gPlayerAnimationMoveLeft:update(dt)
	elseif (gPlayerState == kPlayerStateMoveRight) then
		gPlayerAnimationMoveRight:update(dt)
	end
	
    --~ if (bPressed_Up) then gCamY = gCamY - s end
    --~ if (bPressed_Down) then gCamY = gCamY + s end
    --~ if (bPressed_Left) then gCamX = gCamX - s end
    --~ if (bPressed_Right) then gCamX = gCamX + s end
	
    --~ if (bPressed_Up) then gPlayer.y = gPlayer.y - s end
    --~ if (bPressed_Down) then gPlayer.y = gPlayer.y + s end
    --~ if (bPressed_Left) then gPlayer.x = gPlayer.x - s end
    --~ if (bPressed_Right) then gPlayer.x = gPlayer.x + s end
	
	HandleCollision(gPlayer)
	local bIsOnGround = gPlayer.bIsOnGround
	
	
	-- jump and left-right movement
	if (bPressed_Up and bIsOnGround) then gPlayer.vy = gPlayerJumpVY end
	local vxadd = 0
	if (bPressed_Left ) then vxadd = vxadd + -gPlayer.vxAccelPerSecond end
	if (bPressed_Right) then vxadd = vxadd +  gPlayer.vxAccelPerSecond end
	
	-- xspeed accell or friction
	if (vxadd == 0) then 
		gPlayer.vx = gPlayer.vx*gPlayerOnGroundStopXMult
	else
		gPlayer.vx = gPlayer.vx + vxadd*dt
	end
	
	-- limit x speed
	gPlayer.vx = max(-gPlayer.vxMax,min(gPlayer.vxMax,gPlayer.vx))
	
	-- apply velocity and gravity
	gPlayer.x = gPlayer.x + gPlayer.vx * dt 
	gPlayer.y = gPlayer.y + gPlayer.vy * dt 
	gPlayer.vy = gPlayer.vy + gPlayerGravity*dt
	--~ if (not bIsOnGround) then gPlayer.vy = gPlayer.vy + gPlayerGravity*dt end
	
	
	
	-- move cam to player
	
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	local f = 0.05
	local fi = 1-f
	
	gCamX = max(screen_w/2,fi * gCamX + f * (gPlayer.x + 0.2*screen_w))
end
	
