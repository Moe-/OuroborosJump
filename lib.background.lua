
gAbsoluteCamAddX = 0

function Background_Init ()
	gImgMountain		= getCachedPaddedImage("data/Mountain2.png")
	
	local maxx,miny,maxy = TiledMap_GetMapWUsed()
	gBackGroundMaxY = maxy
end


function Background_Draw ()
	-- gMapUsedW
	local camx = gCamX + gAbsoluteCamAddX
	local camy = gCamY
	print(camx)
	local mx = 1024 -camx * 1 / 4
	local my = 256 - camy * 1 / 4
	local w = 1024 -- width of mountain
	local md = w*1.5 -- distance between mountains
	
	while (mx < -w) do mx = mx + md end
	for i=0,2 do love.graphics.draw(gImgMountain,mx + md*i,my) end
	
end
function Background_NotifyNextMapCycle()
	gAbsoluteCamAddX = gAbsoluteCamAddX + gMapUsedW*kTileSize
end
