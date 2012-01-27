---------------------------------
--! @file
--! @brief Distance calculations
---------------------------------

--! ---

--! @brief distance between line a and b UNTESTED
--! @param ax,ay,az vector, basepoint line a
--! @param ux,uy,uz vector, direction line a
--! @param bx,by,bz vector, basepoint line b
--! @param vx,vy,vz vector, direction line b
--! @return number distance
function DistLineToLine (ax,ay,az, ux,uy,uz, bx,by,bz, vx,vy,vz)
	local p1p2x, p1p2y, p1p2z = Vector.sub(ax,ay,az, bx,by,bz)
	local lenu = Vector.len(ux,uy,uz)
	local lenv = Vector.len(vx,vy,vz)
	local uv = Vector.dot(ux,uy,uz, vx,vy,vz)
	
	local sub = lenu*lenu*lenv*lenv - uv*uv
	local s = (uv * Vector.dot(vx,vy,vz, p1p2x, p1p2y, p1p2z) - lenv*lenv*Vector.dot(ux,uy,uz, p1p2x, p1p2y, p1p2z)) / (sub)
	local t = (lenu*lenu*Vector.dot(ux,uy,uz, p1p2x, p1p2y, p1p2z) - uv * Vector.dot(ux,uy,uz, p1p2x, p1p2y, p1p2z)) / (sub)
	
	local l1x,l1y,l1z = Vector.add(ax,ay,az, Vector.scalarmult(s, ux,uy,uz))
	local l2x,l2y,l2z = Vector.add(bx,by,bz, Vector.scalarmult(t, vx,vy,vz))
	
	return Vector.len(Vector.sub(l1x,l1y,l1z, l2x,l2y,l2z))
end


--! @brief minimal distance between 2 spheres a and b
--! if return value > 0 => value min dist between both
--! if return value <= 0 => abs(value) is lengt of overlapping
--! @param ax,ay,az vector, sphere a center
--! @param ar number, sphere a radius
--! @param bx,by,bz vector, sphere b center
--! @param br number, sphere b radius
--! @return number distance
function MinDistSphereSphere(ax,ay,az,ar, bx,by,bz,br)
	local dist = DistPointToPoint(ax,ay,az, bx,by,bz)
	local overlapp = dist - ar - br
	return overlapp
end

--! @brief point point distance
--! @param ax,ay,az vector
--! @param bx,by,bz vector
--! @return number the distance between point a and point b
function DistPointToPoint (ax,ay,az, bx,by,bz)
	local dx,dy,dz = Vector.sub(ax,ay,az, bx,by,bz)
	return Vector.len(dx,dy,dz)
end


--! @brief distance between point p and plane (base b, normal n)
--! @param px,py,pz vector, point
--! @param bx,by,bz vector, base point of plane
--! @param nx,ny,nz vector, plane normal
--! @return number distance
function DistPointToPlane (px,py,pz, bx,by,bz, nx,ny,nz)
	local dx,dy,dz = Vector.sub(bx,by,bz, px,py,pz)
	local d = Vector.dot(dx,dy,dz, nx,ny,nz)
	local lenn = Vector.len(nx,ny,nz)
	return (d*d) / (lenn*lenn)
end

--! @brief distance between point p and line (base b, direction d) UNTESTED
--! @param px,py,pz vector, point
--! @param bx,by,bz vector, base point of line
--! @param dx,dy,dz vector, line direction
--! @return number distance
function DistPointToLine (px,py,pz, bx,by,bz, dx,dy,dz)
	local qp0x,qp0y,qp0z = Vector.sub(px,py,pz, bx,by,bz)
	local lenv = Vector.len(dx,dy,dz)
	local qp0v = Vector.dot(qp0x,qp0y,qp0z, dx,dy,dz)
	local lenqp0 = Vector.len(qp0x,qp0y,qp0z)
	return lenqp0 * lenqp0 - (qp0v * qp0v) / (lenv * lenv)
end

--! @brief squared 3d distance between a and b
--! @param ax,ay,az vector3
--! @param bx,by,bz vector3
--! @return number
function DistPointToPointSquare (ax,ay,az,bx,by,bz) 
	local dx = ax-bx
	local dy = ay-by
	local dz = az-bz
	return dx*dx + dy*dy + dz*dz
end
