---------------------------------
--! @file
--! @brief Vector2 (x,y)
---------------------------------


--- --------------------

--! @brief vector2 dot product
--! @param x1,y1 vector1
--! @param x2,y2 vector2
--! @return number, v1 dot v2
function dot2		(x1,y1,x2,y2) 
	return x1 * x2 + y1 * y2 
end

--! @brief vector2 addition
--! @param x1,y1 vector1
--! @param x2,y2 vector2
--! @return x,y vector, v1+v2
function add2		(x1,y1,x2,y2) 
	return x1+x2,y1+y2 
end

--! @brief vector2 subtraction
--! @param x1,y1 vector1
--! @param x2,y2 vector2
--! @return x,y vector, v1-v2
function sub2		(x1,y1,x2,y2) 
	return x1-x2,y1-y2
end

--! @brief vector2 sqrlength
--! @param x,y vector
--! @return number quadratic length
function sqlen2		(x,y) 
	return x*x + y*y 
end

--! @brief vector2 length
--! @param x,y vector
--! @return number length
function len2		(x,y) 
	return math.sqrt(x*x + y*y) 
end

--! @brief vector2 scale
--! @param s number
--! @param x,y vector
--! @return x,y vector, scaled with s
function scale2		(s,x,y) 
	return x*s,y*s 
end

--! @brief vector2 normalize
--! @param x,y vector
--! @return x,y vector, with length 1
function norm2		(x,y) 
	local s = 1.0/len2(x,y) 
	return x*s,y*s 
end

--! @brief vector2 normalize to length
--! @param x,y vector
--! @param l number
--! @return x,y vector, with length l
function tolen2		(x,y,l) 
	local s = l/len2(x,y) 
	return x*s,y*s 
end

--! @brief vector2 rotate
--! @param x,y vector
--! @param a number, radian
--! @return x,y vector, rotated
function rotate2	(x,y,a) 
	local vsin,vcos = sin(a),cos(a) 
	return x*vcos-y*vsin, x*vsin+y*vcos 
end


--! @brief squared 2d distance
--! @param ax,ay vector2
--! @param bx,by vector2
--! @return number
function sqdist2 (ax,ay,bx,by) 
	local dx = ax-bx
	local dy = ay-by
	return dx*dx + dy*dy
end


--! @brief distance between 2 vector2
--! @param ax,ay vector2
--! @param bx,by vector2
--! @return number distance
function dist2 (ax,ay,bx,by)		
	return math.sqrt(sqdist2(ax,ay,bx,by)) 
end

--! @brief manhattan distance 2d
--! @param ax,ay vector2
--! @param bx,by vector2
--! @return number distance_max
function dist2max (ax,ay,bx,by)		
	return max(abs(ax-bx),abs(ay-by)) 
end

-- points in a random direction
function randomVector2WithLength(len)
	len = len or 1
	local rotation = math.random() * 2 * math.pi
	return math.cos(rotation) * len, math.sin(rotation) * len
end
