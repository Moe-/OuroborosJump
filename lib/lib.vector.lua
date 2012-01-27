---------------------------------
--! @file
--! @brief Vector (x,y,z)
---------------------------------

--! namespace
Vector = {}

--! @brief generates random vector
--! @return x,y,z vector, every coord is in [0,1)
function Vector.random ()
	return math.random(),math.random(),math.random()
end

--! @brief generates random vector between given borders
--! @param minx, miny, minz min borders
--! @param maxx, maxy, maxz max borders
--! @return x,y,z vector, every coord is in [min,max) each
function Vector.random2 (minx,miny,minz,maxx,maxy,maxz)
	return	minx + math.random()*(maxx-minx),
			miny + math.random()*(maxy-miny),
			minz + math.random()*(maxz-minz)
end

--! @brief generates random vector between -v and v each
--! @param v bound value on each axis around 0
--! @return x,y,z vector, every coord is in [-v,v)
function Vector.random3 (v)
	return Vector.random2(-v,-v,-v,v,v,v)
end

--! @brief rolls the components in the vector
--! ie. times=1 x,y,z -> z,y,x
--! @param x,y,z vector
--! @param number of times to roll
--! @return x,y,z vector
function Vector.roll (x,y,z, times)
	times = times or 1
	
	while times < 0 do
		times = times + 3
	end
	
	times = math.fmod(times,3)
	
	if times == 0 then
		return x,y,z
	elseif times == 1 then
		return z,x,y
	else
		return y,z,x
	end
end

--! @brief vector length
--! @param x,y,z vector
--! @return float length of x,y,z
function Vector.len (x,y,z)
	return math.sqrt(x*x+y*y+z*z)
end

--! @brief vector length squared
--! @param x,y,z vector
--! @return float length of x,y,z
function Vector.sqlen (x,y,z)
	return x*x+y*y+z*z
end


--! @brief compares to vectors
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return true if equal
function Vector.compare (x1,y1,z1, x2,y2,z2) 
	return x1 == x2 and y1 == y2 and z1 == z2 
end

--! @brief normalize
--! @param x,y,z vector
--! @return x,y,z vector with length = 1.0
function Vector.normalise (x,y,z)
	local len = Vector.len(x,y,z)
	if (len > 0) then 
		return x/len,y/len,z/len
	else
		return 1,0,0
	end
end

--! @brief normalize to length
--! @param x,y,z vector
--! @param normlen target vector length
--! @return x,y,z vector with length = normlen
function Vector.normalise_to_len (x,y,z,normlen)
	local len = Vector.len(x,y,z) / normlen
	if (len > 0) then 
		return x/len,y/len,z/len
	else
		return 1,0,0
	end
end

--! @brief vector cross product
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return x,y,z vector, Ogre::v1.crossProduct(v2)
function Vector.cross (x1,y1,z1,x2,y2,z2)
	return y1 * z2 - z1 * y2 , z1 * x2 - x1 * z2 , x1 * y2 - y1 * x2
end

--! @brief vector dot product
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return number, Ogre::v1.dotProduct(v2)
function Vector.dot (x1,y1,z1,x2,y2,z2)
	return x1 * x2 + y1 * y2 + z1 * z2
end

--! @brief vector scalar product
--! @param f number scalar
--! @param x1,y1,z1 vector1
--! @return x,y,z vector, vec * scal
function Vector.scalarmult (f, x,y,z)
	return x*f, y*f, z*f
end

--! @brief vector subtraction
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return x,y,z vector v1-v2
function Vector.sub (x1,y1,z1,x2,y2,z2)
	return x1-x2, y1-y2, z1-z2
end

--! @brief vector addition
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return x,y,z vector v1+v2
function Vector.add (x1,y1,z1,x2,y2,z2)
	return x1+x2, y1+y2, z1+z2
end

--! @brief vector addition with scaled vector
--! @param s scale factor
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2, gets scaled
--! @return x,y,z vector v1+v2*s
function Vector.addscaled (s,x1,y1,z1,x2,y2,z2)
	return x1+x2*s, y1+y2*s, z1+z2*s
end

--! @brief scales each vector component
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return x,y,z vector scaled each with factors from vector2
function Vector.scale (x1,y1,z1,x2,y2,z2)
	return x1*x2, y1*y2, z1*z2
end

--! @brief vector addition
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @param x3,y3,z3 vector3
--! @return x,y,z vector v1+v2+v3
function Vector.add3 (x1,y1,z1,x2,y2,z2,x3,y3,z3)
	return x1+x2+x3, y1+y2+y3, z1+z2+z3
end

--! @brief vector addition
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @param x3,y3,z3 vector3
--! @param x4,y4,z4 vector4
--! @return x,y,z vector v1+v2+v3+v4
function Vector.add4 (x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4)
	return x1+x2+x3+x4, y1+y2+y3+y4, z1+z2+z3+z4
end

--! @brief vector addition (0-index array based)
--! @param v1 vector1 {0=x,1=y,2=z}
--! @param v2 vector2 {0=x,1=y,2=z}
--! @param v3 vector3 {0=x,1=y,2=z}
--! @param v4 vector4 {0=x,1=y,2=z}
--! @return x,y,z vector v1+v2+v3+v4
function Vector.add4v (v1,v2,v3,v4)
	return v1[0]+v2[0]+v3[0]+v4[0], v1[1]+v2[1]+v3[1]+v4[1], v1[2]+v2[2]+v3[2]+v4[2]
end

--! @brief project v1 onto v2
--! @param x1,y1,z1 vector1
--! @param x2,y2,z2 vector2
--! @return x,y,z vector
function Vector.project_on_vector (x1,y1,z1,x2,y2,z2)
	return Vector.scalarmult(Vector.dot(x1,y1,z1,x2,y2,z2) / Vector.dot(x2,y2,z2,x2,y2,z2), x2,y2,z2)
end

--! @brief project x,y,z on the plane with normal nx,ny,nz
--! @param x,y,z vector
--! @param nx,ny,nz vector, plane normal
--! @return x,y,z vector
function Vector.project_on_plane (x,y,z,nx,ny,nz)
	return Vector.sub(x,y,z, Vector.project_on_vector(x,y,z, nx,ny,nz))
end

--! @brief creates 0-index based vector
--! @param x,y,z vector
--! @return 0-index based array {0=x,1=y,2=z}
function Vector.create( x, y, z )
	local vec = {}
	vec[0] = x
	vec[1] = y
	vec[2] = z
	return vec
end

--! @brief is length almost zero, inspired by ogre
--! @param x,y,z vector
--! @return bool true if almost zero
function Vector.isZeroLength (x,y,z)
	return x*x + y*y + z*z < 0.00000000001
end


function Vector.lerp (x0,y0,z0, x1,y1,z1, f)
	return MapFromTo (f, 0,1, x0, x1),
		MapFromTo (f, 0,1, y0, y1),
		MapFromTo (f, 0,1, z0, z1)
end

