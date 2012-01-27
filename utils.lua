
function getCachedImage (imageFile)
	local img

	if imageCache and imageCache[imageFile] then
		img = imageCache[imageFile]
	else
		img = love.graphics.newImage(imageFile)
		imageCache = imageCache or {}
		imageCache[imageFile] = img
	end
	
	return img
end


gGfxSourceSizes = {}
function getGfxSourceSize(gfx)
	local arr = gGfxSourceSizes[gfx]
	if (arr) then return unpack(arr) end
end

function newPaddedImage(filename)
    local source = love.image.newImageData(filename)
    local w, h = source:getWidth(), source:getHeight()
    -- Find closest power-of-two.
    local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
    local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))
    
    local gfx = nil
    
    -- Only pad if needed:
    if wp ~= w or hp ~= h then
        local padded = love.image.newImageData(wp, hp)
        padded:paste(source, 0, 0)
        gfx = love.graphics.newImage(padded)
    else
		gfx = love.graphics.newImage(source)
	end
    
    -- originalgroesse in die groessenfunctionen patchen
    local sourceW = source:getWidth()
    local sourceH = source:getHeight()
    
    gGfxSourceSizes[gfx] = {sourceW, sourceH}
    
    return gfx
end


function getCachedPaddedImage (imageFile)
	local img

	if imageCachePadded and imageCachePadded[imageFile] then
		img = imageCachePadded[imageFile]
	else
		img = newPaddedImage(imageFile)
		imageCachePadded = imageCachePadded or {}
		imageCachePadded[imageFile] = img
	end
	
	return img
end

function findNearestObjectInKeyList(x,y, list, ignoreThis)
	local nearest, mindist = nil,nil
	
	for k,v in pairs(list) do
		if k ~= ignoreThis and k.x and k.y then
			local dist = sqlen2(x - k.x, y - k.y)
			
			if mindist == nil or dist < mindist then
				nearest = k
				mindist = dist
			end
		end
	end
	
	return nearest, mindist and math.sqrt(mindist) or nil
end

function findNearestObjectInKeyLists(x,y, lists, ignoreThis)
	local nearest, mindist = nil,nil

	for k,list in pairs(lists) do
		local n, dist = findNearestObjectInKeyList(x,y,list,ignoreThis)
		
		if mindist == nil or dist < mindist then
			nearest = n
			mindist = dist
		end
	end

	return nearest, mindist
end


function VectorLength(vx,vy) return math.sqrt(vx*vx + vy*vy) end
function VectorNormalized(vx,vy) local f = VectorLength(vx,vy) f = (f==0) and 1 or 1/f return f*vx,f*vy end
function VectorDot(ax,ay,bx,by) return ax*bx + ay*by end
function VectorNormDot(ax,ay,bx,by)
	ax,ay = VectorNormalized(ax,ay)
	bx,by = VectorNormalized(bx,by)
	return VectorDot(ax,ay,bx,by)
end
function Point2PointDistance(x1, y1, x2, y2) return VectorLength(x2 - x1,y2 - y1) end

function rand2 (vmin,vmax) return vmin + (vmax-vmin)*math.random() end


-- a chain that applies varying force to pull 2 bodys together, 0 if distance below chainLenMinF
function RobApplyChainForce (bodyA,bodyB, anchorAx,anchorAy, anchorBx,anchorBy, forceMin,forceMax, chainLenMinF,chainLenMaxF) 
	local x1,y1 = bodyA:getWorldCenter( )
	local x2,y2 = bodyB:getWorldCenter( )
	local d = Point2PointDistance(x1, y1, x2, y2)
	if (d >= chainLenMinF) then
		local f = max(0,min(1, (d-chainLenMinF) / (chainLenMaxF-chainLenMinF) ))
		if (gKeyPressed["lshift"]) then print("chainforce:",f) end
		local m1 = bodyA:getMass()
		local m2 = bodyB:getMass()
		local force = forceMin + (forceMax-forceMin) * f
		local vx,vy = VectorNormalized(x1-x2,y1-y2)
		
		local ax1,ay1 = bodyA:getWorldPoint(anchorAx,anchorAy)
		local ax2,ay2 = bodyB:getWorldPoint(anchorBx,anchorBy)
		
		bodyA:applyForce(-force*vx,-force*vy, ax1,ay1)
		bodyB:applyForce( force*vx, force*vy, ax2,ay2)
	end
end


