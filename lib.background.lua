
gAbsoluteCamAddX = 0

gWolken = {}


function Background_Init ()
	gImgMountain		= getCachedPaddedImage("data/Mountain2.png")
	gImgWolke			= getCachedPaddedImage("data/Wolke2.png")
	gImgHimmel			= getCachedPaddedImage("data/Himmel2.jpg")
	
	local maxx,miny,maxy = TiledMap_GetMapWUsed()
	gBackGroundMaxY = maxy
	
	gWolken = {}
	for i=1,5 do table.insert(gWolken,{bAlive = false}) end
end


function Background_Step (dt)
	gBackgroundLastDT = dt
end

function Background_Draw ()
	-- gMapUsedW
	local camx = gCamX + gAbsoluteCamAddX
	local camy = gCamY
	local fpy = 0.8
	
	-- wolken
	local dt = gBackgroundLastDT or 0
	local ww = 256
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
	local kWolkeMountainZ = 6
	
	-- himmel
	love.graphics.draw(gImgHimmel,0,0)
	
	-- wolken draw
	for k,o in ipairs(gWolken) do 
		if (o.bAlive and o.z < kWolkeMountainZ) then
			local mx = o.x -       camx * 1 / o.parallax_x
			local my = o.y - fpy * camy * 1 / o.parallax_y 
			love.graphics.draw(gImgWolke,mx,my,0,o.s,o.s)
		end
	end
	
	-- mountain :
	local mx = 1024 -       camx * 1 / kWolkeMountainZ
	local my = 100  - fpy * camy * 1 / kWolkeMountainZ
	local w = 1024 -- width of mountain
	local md = w*1.5 -- distance between mountains
	
	while (mx < -w) do mx = mx + md end
	for i=0,2 do love.graphics.draw(gImgMountain,mx + md*i,my) end
	
	
	-- wolken draw
	for k,o in ipairs(gWolken) do 
		if (o.bAlive and o.z >= kWolkeMountainZ) then
			local mx = o.x -       camx * 1 / o.parallax_x
			local my = o.y - fpy * camy * 1 / o.parallax_y
			love.graphics.draw(gImgWolke,mx,my,0,o.s,o.s)
		end
	end
	
	-- wolken
	for k,o in ipairs(gWolken) do 
		if (o.bAlive) then
			o.x = o.x + o.vx*dt
			o.y = o.y + o.vy*dt
			if (o.x + ww*o.s - camx * 1 / o.parallax_x < 0) then o.bAlive = false end
		elseif (math.random() < 0.1) then 
			o.bAlive = true
			local maxs = 50
			o.vx = rand2(-maxs,0)
			o.vy = 0
			o.z = rand2(5,8)
			o.parallax_x = o.z
			o.parallax_y = o.parallax_x
			o.s = o.z / 6
			o.x = rand2(screen_w*1.00,screen_h*4.75)    + camx * 1 / o.parallax_x
			o.y = rand2(screen_h*0.0,screen_h*0.50) 	+ camy * 1 / o.parallax_y
		end
	end
	
end


function Background_NotifyNextMapCycle()
	gAbsoluteCamAddX = gAbsoluteCamAddX + gMapUsedW*kTileSize
end
