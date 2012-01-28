
gCollisionDebugDrawList = {}
function CollisionDrawDebug_Step ()
	for k,v in ipairs(gCollisionDebugDrawList) do love.graphics.draw(unpack(v)) end
	gCollisionDebugDrawList = {}
end
function CollisionDrawDebug_Add (img,x,y) table.insert(gCollisionDebugDrawList,{img,x+gCamAddX,y+gCamAddY}) end

function CollisionDebugStep ()
end
function CollisionDebugDraw ()
	local o = {} for k,v in pairs(gPlayer) do o[k] = v end
	
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	o.x = mx - gCamAddX
	o.y = my - gCamAddY
	HandleCollision2(o)
	gPlayerAnimationIdleLeft:draw(o.x+o.drawx+gCamAddX, o.y+o.drawy+gCamAddY, 0, 1, 1, 0, 0)
end

function HandleCollision (o)
	o.bIsOnGround = false
	
	HandleCollision2(o)
	
	local bottom_y = 11*kTileSize
	if (o.y > bottom_y) then
		o.y = bottom_y
		if (o.vy > 0) then o.vy = 0 o.bIsOnGround = true end
	end
end

function HandleCollision2 (o)
	o.bIsOnGround = false
	--~ local tx = 
	--~ love.graphics.draw(gImgDot, x+gCamAddX, y+gCamAddY )
	
	local e = kTileSize
	local x,y,r = o.x,o.y,o.r
	local b = 0.1*e
	local tx0,tx1 = floor((x-r-b)/e)-1,floor((x+r+b)/e)+1
	local ty0,ty1 = floor((y-r-b)/e)-1,floor((y+r+b)/e)+1
	for tx = tx0,tx1 do
	for ty = ty0,ty1 do
		if (IsMapBlockSolid(tx,ty)) then CollisionPushOutBox(o,tx*e,ty*e,e,e) end
	end
	end
	
	
	
	--~ local tx0,tx1 = floor(mx/e),floor(r/e)
	--~ local ty0,ty1 = floor((t+m)/e),floor((b-m)/e)
	--~ for tx = tx0,tx1 do 
	--~ for ty = ty0,ty1 do 
		--~ if (IsMapBlockSolid(tx,ty)) then local v = tx*e - gPlayerW maxx = min(maxx or v,v) end
	--~ end
	--~ end

	--~ if (gPlayer.y >= maxy) then
		--~ gPlayer.y = maxy
		--~ bIsOnGround = true
		--~ if (gPlayer.vy > 0) then gPlayer.vy = 0 end
	--~ end
	
end

function CollisionPushOutBox (o,bx,by,bw,bh) 
	local x,y,r = o.x,o.y,o.r
	if (y+r < by   ) then return end
	if (y-r > by+bh) then return end
	if (x+r < bx   ) then return end
	if (x-r > bx+bw) then return end
	local out_x
	local out_y
	
	CollisionDrawDebug_Add(gImgMarkTile_white,bx,by)
	
	
	-- calc moved-out-positions, either x or y
	if (x < bx   ) then out_x = bx   -r CollisionDrawDebug_Add(gImgMarkTile_white,bx,by) end
	if (x > bx+bw) then out_x = bx+bw+r CollisionDrawDebug_Add(gImgMarkTile_white,bx,by) end
	if (y < by   ) then out_y = by   -r CollisionDrawDebug_Add(gImgMarkTile_white,bx,by) end
	if (y > by+bh) then out_y = by+bh+r CollisionDrawDebug_Add(gImgMarkTile_white,bx,by) end
	--~ print("CollisionPushOutBox",out_x,out_y)
	
	-- if both moveouts are possible, choose the shorter distance and disable the other
	if (out_x and out_y) then 
		if (abs(out_x-x) < abs(out_y-y)) then out_y = nil else out_x = nil end
	end
	
	-- now only one of the two will be active
	if (out_x) then
		o.x = out_x
		if (out_x < x and o.vx > 0) then o.vx = 0 end -- blocked right
		if (out_x > x and o.vx < 0) then o.vx = 0 end -- blocked left
	end
	if (out_y) then
		o.y = out_y
		if (out_y < y and o.vy > 0) then o.vy = 0 o.bIsOnGround = true end -- blocked bottom
		if (out_y > y and o.vy < 0) then o.vy = 0 end -- blocked top
	end
end

