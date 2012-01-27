---------------------------------
--! @file
--! @brief Quaternion (w,x,y,z)
---------------------------------

--! namespace
Quaternion = {}

--! @brief converts quaternion to angle and axis
--! @param qw,qx,qy,qz quaternion
--! @return ang,x,y,z 	ang=angle in radian, x,y,z axis vector
function Quaternion.toAngleAxis (qw,qx,qy,qz)
	return QuaternionToAngleAxis(qw,qx,qy,qz)
end

--! @brief blends between 2 rotations
--! @param qw,qx,qy,qz quaternion start
--! @param pw,px,py,pz quaternion end
--! @param t number blend factor, 0-1
--! @param bShortestPath bool, optional (default=true)
--! @return w,x,y,z quaternion
function Quaternion.Slerp (qw,qx,qy,qz, pw,px,py,pz, t, bShortestPath)
	return QuaternionSlerp(qw,qx,qy,qz, pw,px,py,pz, t, bShortestPath)
end

--! @brief converts a angle axis rotation into a quaternion
--! @param ang number, radian
--! @param x,y,z vector, axis, must be normalized, see Vector.normalise
--! @return w,x,y,z quaternion
function Quaternion.fromAngleAxis (ang,x,y,z)
	local halfang = 0.5 * ang
	local fsin = math.sin(halfang)
	return math.cos(halfang) , fsin*x , fsin*y , fsin*z
end

--! @brief inverse of unit length rotation
--! @param w,x,y,z quaternion, must be unit length
--! @return w,x,y,z quaternion, inverse
function Quaternion.inverse 	(w,x,y,z) 
	return w,-x,-y,-z  
end

--! @brief rotation one element
--! @return w,x,y,z quaternion
function Quaternion.identity 	() 
	return 1,0,0,0 
end

--! @brief squared len of quaternion?
--! @param w,x,y,z quaternion
--! @return number
function Quaternion.norm 		(w,x,y,z) 
	return w*w+x*x+y*y+z*z 
end

--! @brief normalized rotation
--! @param w,x,y,z quaternion
--! @param w,x,y,z quaternion
function Quaternion.normalise 	(w,x,y,z) 
	local factor = 1.0 / math.sqrt(w*w+x*x+y*y+z*z)
	return w*factor,x*factor,y*factor,z*factor 
end

--! @brief a rotation with length=ang around a random axis
--! @param ang number, ang defaults to random
--! @return qw,qx,qy,qz quaternion
function Quaternion.random (ang)
	if ang == nil then ang = math.pi*(2.0*math.random() - 1.0) end
	local x,y,z = Vector.random()
	x,y,z = Vector.normalise(x,y,z)
	return Quaternion.fromAngleAxis( ang , x,y,z )
end

--! @brief the shortest arc quaternion to rotate vector1 to vector2
--! @param x1,y1,z1 vector, from
--! @param x2,y2,z2 vector, to
--! @return qw,qx,qy,qz quaternion
function Quaternion.getRotation (x1,y1,z1,x2,y2,z2) 
	-- based on Ogre::v1.getRotationTo(v2), based on Stan Melax's article in Game Programming Gems
	x1,y1,z1 = Vector.normalise(x1,y1,z1)
	x2,y2,z2 = Vector.normalise(x2,y2,z2)
	local d = Vector.dot(x1,y1,z1,x2,y2,z2)
	-- If dot == 1, vectors are the same
	if (d >= 1.0) then
		return Quaternion.identity()
	else 
		local s = math.sqrt( (1+d)*2 )
		if (s < 0.000001) then
			-- If you call this with a dest vector that is close to the inverse of this vector, 
			-- we will rotate 180 degrees around a generated axis since in this case ANY axis of rotation is valid.
			local xa,ya,za = Vector.cross(1,0,0,x1,y1,z1)
			if (Vector.isZeroLength(xa,ya,za)) then -- pick another if colinear
				xa,ya,za = Vector.cross(0,1,0,x1,y1,z1)
			end
			xa,ya,za = Vector.normalise(xa,ya,za)
			return Quaternion.fromAngleAxis(math.pi,xa,ya,za)
		else
			local invs = 1 / s
			local xc,yc,zc = Vector.cross(x1,y1,z1,x2,y2,z2)
			return s * 0.5 , xc * invs , yc * invs , zc * invs
		end
	end
end

--! @brief rotates vector
--! @param x,y,z vector
--! @param qw,qx,qy,qz quaternion rotation
--! @return x,y,z vector, rotated
function Quaternion.applyToVector (x,y,z,qw,qx,qy,qz) 
	-- inspired by Ogre::Quaternion operator* (Vector3)
	local uv_x,uv_y,uv_z = Vector.cross(qx,qy,qz,x,y,z)
	local uuv_x,uuv_y,uuv_z = Vector.cross(qx,qy,qz,uv_x,uv_y,uv_z)
	uv_x,uv_y,uv_z = Vector.scalarmult(2.0 * qw, uv_x,uv_y,uv_z)
	uuv_x,uuv_y,uuv_z = Vector.scalarmult(2.0, uuv_x,uuv_y,uuv_z)
	return Vector.add3(x,y,z , uv_x,uv_y,uv_z , uuv_x,uuv_y,uuv_z)
end


--! @brief Mul(a,b) = a*b, multiplies two quaternions, generally not commutative (a*b != b*a)
--! @param aw,ax,ay,az quaternion
--! @param bw,bx,by,bz quaternion
--! @return qw,qx,qy,qz quaternion
function Quaternion.Mul (aw,ax,ay,az,bw,bx,by,bz) 
	-- inspired by Ogre::Quaternion operator* (Quaternion)
	return	aw * bw - ax * bx - ay * by - az * bz,
			aw * bx + ax * bw + ay * bz - az * by,
			aw * by + ay * bw + az * bx - ax * bz,
			aw * bz + az * bw + ax * by - ay * bx
end

--! @brief converts comma seperated list to quaternion
--! @param txt string, eg. x:90,y:90,z:30
--! @return qw,qx,qy,qz quaternion
function Quaternion.FromString (txt) 
	local qw,qx,qy,qz = Quaternion.identity()
	local arr = str.split(",",txt)
	for k,axis_ang in pairs(arr) do
		local axis,ang = unpack(str.split(":",axis_ang))
		local x,y,z = 0,0,0
			if (axis == "x") then x = 1 
		elseif (axis == "y") then y = 1 
		elseif (axis == "z") then z = 1 
		else assert(false,"illegal axis"..tostring(axis))
		end
		local ow,ox,oy,oz = Quaternion.fromAngleAxis(tonumber(ang)*gfDeg2Rad,x,y,z)
		qw,qx,qy,qz = Quaternion.Mul(ow,ox,oy,oz,qw,qx,qy,qz) 
	end
	return qw,qx,qy,qz
end

--! @brief reduces a turn-quaternions angle, t=1 = no change
--! @param qw,qx,qy,qz quaternion
--! @param t number, angle scale factor
--! @return qw,qx,qy,qz quaternion
function Quaternion.reduce (qw,qx,qy,qz,t) 
	local ang,x,y,z = Quaternion.toAngleAxis(qw,qx,qy,qz)
	return Quaternion.fromAngleAxis(ang*t,x,y,z)
end

--! @brief changes the rotation angle while leaving the axis
--! @param qw,qx,qy,qz quaternion
--! @param newang number, radian, overwrites old angle
--! @return qw,qx,qy,qz quaternion
function Quaternion.setAngle (qw,qx,qy,qz,newang) 
	local ang,x,y,z = Quaternion.toAngleAxis(qw,qx,qy,qz)
	return Quaternion.fromAngleAxis(newang,x,y,z)
end

--! @brief rotation angle in radians
--! @param qw,qx,qy,qz quaternion
--! @return number, angle in radians
function Quaternion.getAngle (qw,qx,qy,qz) 
	local ang,x,y,z = Quaternion.toAngleAxis(qw,qx,qy,qz)
	return ang
end

--! @brief lookat rotation with upvector 0,0,1
--! @param x,y,z vector, target
--! @return qw,qx,qy,qz quaternion
function Quaternion.lookAt (x,y,z) 
	return Quaternion.getRotation(0,0,1,x,y,z)
end
