---------------------------------
--! @file
--! @brief basic math and distance functions
---------------------------------

--! 3.1415
kPi = math.pi 

--! coverts degree to radian
gfDeg2Rad = kPi / 180.0
--! converts radian to degree
gfRad2Deg = 180.0 / kPi

-- shortcuts
sin = math.sin
cos = math.cos
max = math.max
min = math.min
floor = math.floor
ceil = math.ceil
sqrt = math.sqrt
abs = math.abs
mod = math.fmod


--! @brief signum
--! @param x number
--! @return number -1,0,1
function sign (x) 
	return (x==0) and 0 or ((x<0) and -1 or 1) 
end

--! @brief hypotenuse of a right-angle triangle
--! @param dx,dy vector2
--! @return number
function hypot (dx,dy) 
	return math.sqrt(dx*dx + dy*dy) 
end

--! @param x number
--! @return number
function round (x) 
	return math.floor(0.5 + x) 
end

--! @brief rounds mupliple inputs each
--! @param number, ...
--! @return number, ...
function roundmultiple (...)
	local res = {}
	for k,x in pairs(arg) do res[k] = math.floor(0.5 + x) end
	return unpack(res)
end


--! @brief interpolation between p1 and p2, the order is  q1  p1  p2  q2
--! @param t number, blend factor, 0-1
--! @param q1 number?
--! @param p1 number, start
--! @param p2 number, end
--! @param q2 number?
--! @return number
function InterpolateSmooth4 (t,q1,p1,p2,q2) 
	if (t < 0) then return p1 end
	if (t > 1) then return p2 end
	--~ 	//Q(t) = P1*(2t^3-3t^2+1) + R1*(t^3-2t^2+t) + P2*(-2t^3+3t^2) + R2*(t^3-t^2)
	--~ 	//Q(0) = P1*(1) + R1*(0) + P2*(0) + R2*(0)
	--~ 	//Q(1) = P1*(0) + R1*(0) + P2*(1) + R2*(0)
	--~ 	// hermit spline or something like that
	--~ 	// R1,R2 are tangent-vectors at P1,P2
	local t2 = t * t
	local t3 = t2 * t
	local t3m2 = t3 - t2
	local r1 = (p2 - q1) * 0.5
	local r2 = (q2 - p1) * 0.5
	
	return p1*(t3m2+t3m2-t2+1.0) + r1*(t3m2-t2+t) + p2*(-t3m2-t3m2+t2) + r2*(t3m2) 
end




--! @brief checks if point is on plane
--! @param px,py,pz vector, this point gets checked
--! @param bx,by,bz vector, base of plane
--! @param nx,ny,nz vector, plane normal
--! @return bool true if the given point p is part of the given plane
function IsPointOnPlane (px,py,pz, bx,by,bz, nx,ny,nz)
	local dx,dy,dz = Vector.sub(bx,by,bz, px,py,pz)
	local d = Vector.dot(dx,dy,dz, nx,ny,nz)
	return d == 0
end


--! @brief clamp x to borders
--! @param x number, gets calmped
--! @param v1 number min border
--! @param v2 number max border
--! @return number in [v1,v2]
function Clamp(x, v1,v2)
	local vmin,vmax = math.min(v1,v2), math.max(v1,v2)
	if (x < vmin) then return vmin end
	if (x > vmax) then return vmax end
	return x
end

--! @brief clamp x to one border on both sides
--! @param x number, gets calmped
--! @param len number border
--! @return number in [-len,len]
function ClampLen(x,len)
	return Clamp(x, -len, len)
end
	
--! @brief is point inside AABB
--! @param x,y,z vector, point to check
--! @param minx,miny,minz vector, AABB lower end
--! @param maxx,maxy,maxz vector, AABB higher end
--! @return bool true if there is an intersection
function BBoxIntersectPoint (x,y,z, minx,miny,minz, maxx,maxy,maxz)
	return	minx <= x and x <= maxx and
			miny <= y and y <= maxy and
			minz <= z and z <= maxz
end

--! @brief unit lenght axis directions
--! returns x,y,z (unit-length), dir [0,5] means {x,y,z,-x,-y,-z}
--! @param dir number 0-5
--¡ @return x,y,z vector, unit length
function DirToVector (dir) 
	if (dir == 0) then return 1,0,0 end
	if (dir == 1) then return 0,1,0 end
	if (dir == 2) then return 0,0,1 end
	if (dir == 3) then return -1,0,0 end
	if (dir == 4) then return 0,-1,0 end
	if (dir == 5) then return 0,0,-1 end
end

--! @brief direction of vector
--! only works on normalised vectors that are very close to being aligned to an axis
--! @see DirToVector
--! @param x,y,z vector, must be normalized and close to axis
--! @return number direction in [0,5]
function VectorToDir (x,y,z)
	if (round(x) == 1) then return 0 end
	if (round(y) == 1) then return 1 end
	if (round(z) == 1) then return 2 end
	if (round(x) == -1) then return 3 end
	if (round(y) == -1) then return 4 end
	if (round(z) == -1) then return 5 end
end

--! @brief gets the opposite direction
--! @see DirToVector
--! @param a number 0-5
--! @param number 0-5
function InverseDir (a) 
	return math.fmod(a+3,6) 
end

--! @brief rotation in 90 deg steps around axis 
--! VectorToDir(axisdir) with ang = ang90 * 90 degrees
--! @see DirToVector
--! @param ang90 number of 90 degree rotations
--! @param axisdir number 0-5
--! @return w,x,y,z quaternion
function GetRot90 (ang90,axisdir) 
	return Quaternion.fromAngleAxis((ang90*0.5)*math.pi,DirToVector(axisdir)) 
end

--! returns mx,my,mz,  e.g. (-1,1,1) for (1,0,0) , normal must be ortho
function AxisAlignedNormalToMirror (nx,ny,nz) 
	return 1 - 2*math.abs(round(nx)),1 - 2*math.abs(round(ny)),1 - 2*math.abs(round(nz)) 
end

function ScaleToMirror (sx,sy,sz) 
	return ((sx >= 0)and(1)or(-1)),((sy >= 0)and(1)or(-1)),((sz >= 0)and(1)or(-1)) 
end

--! mirror around origin, defaults to 0,0,0
--! warning! beware of rounding errors due to addition and substraction
--!  e.g. ox,oy,oz should be rounded if you are working on a grid
function MirrorPoint (x,y,z,mx,my,mz,ox,oy,oz) 
	return ox + (x - ox)*mx, oy + (y - oy)*my, oz + (z - oz)*mz 
end

-- returns x1,y1,z1, x2,y2,z2,   corrected after mirroring so that 1:min 2:max
function CorrectBounds (x1,y1,z1, x2,y2,z2)
	return	math.min(x1,x2),math.min(y1,y2),math.min(z1,z2),
			math.max(x1,x2),math.max(y1,y2),math.max(z1,z2)
end

--! returns true if normal is nearly axisaligned
function NormalIsAxisAligned (nx,ny,nz) 
	return math.max(-nx,nx, -ny,ny, -nz,nz) > 0.95 
end

--! returns {["012"]={qw,qx,qy,qz, mx,my,mz},...} : 6*4*2  all possible possible orthagonal rotations and mirror combos 
--! keys come from GetMirRotComboName(...)
--! mx,my,mz in {1,-1}
--! 1st vector free, 2nd vector must be adjacted to 1st , 3rd vector must be orthogonal to 1st and 2nd
function GetAllMirRotCombos ()
	--[[
	idea : first step produces only positive vectors (3*2*1 = 6)
	xyz : identity
	xzy : swap yz : rotate x and mirror one of them
	yxz : swap xy : rotate z and mirror one of them
	zyx : swap xz : rotate y and mirror one of them
	zxy : swap xy : rotate z : yxz : then swap yz : rotate x : and mirror if neccessary (0,1 or 2 mirrors required)
	yzx : swap xy : rotate z : yxz : then swap xz : rotate y : and mirror if neccessary (0,1 or 2 mirrors required)
	the rest is done via mirroring
	we don't really need to get the rotations positive, we just add all 8 mirror-possibilites to the result
	]]--
	
	local myAddOne = function (res, qw,qx,qy,qz, mx,my,mz)
		res[GetMirRotComboName(qw,qx,qy,qz, mx,my,mz)] = {qw,qx,qy,qz, mx,my,mz}
	end
	local myAddAllMirrors = function (res,qw,qx,qy,qz) -- 4*2 = 8 possibilities for mirroring
		myAddOne(res, qw,qx,qy,qz,  1, 1, 1)
		myAddOne(res, qw,qx,qy,qz, -1, 1, 1)
		myAddOne(res, qw,qx,qy,qz,  1,-1, 1)
		myAddOne(res, qw,qx,qy,qz, -1,-1, 1)
		myAddOne(res, qw,qx,qy,qz,  1, 1,-1)
		myAddOne(res, qw,qx,qy,qz, -1, 1,-1)
		myAddOne(res, qw,qx,qy,qz,  1,-1,-1)
		myAddOne(res, qw,qx,qy,qz, -1,-1,-1)
	end
	
	-- 6 possibilities for rotation
	local res = {}
	myAddAllMirrors(res,Quaternion.identity())
	myAddAllMirrors(res,GetRot90(1,0))
	myAddAllMirrors(res,GetRot90(1,1))
	myAddAllMirrors(res,GetRot90(1,2))
	myAddAllMirrors(res,0.5, 0.5,0.5,0.5) -- diagonal rotation1 = rotate_z after rotate_x ?
	myAddAllMirrors(res,0.5,-0.5,0.5,0.5) -- diagonal rotation2 = rotate_z after rotate_y ?
	return res
end

--! returns x,y,z   after applying rotation and mirror
function ApplyMirRotCombo (x,y,z, qw,qx,qy,qz, mx,my,mz)
	return Quaternion.applyToVector(mx*x,my*y,mz*z,qw,qx,qy,qz)
end

--! returns "012" or something like that,  the numbers have the same meaning as dir in DirToVector
function GetMirRotComboName (qw,qx,qy,qz, mx,my,mz)
	return	tostring(VectorToDir(ApplyMirRotCombo(1,0,0, qw,qx,qy,qz, mx,my,mz)))..
			tostring(VectorToDir(ApplyMirRotCombo(0,1,0, qw,qx,qy,qz, mx,my,mz)))..
			tostring(VectorToDir(ApplyMirRotCombo(0,0,1, qw,qx,qy,qz, mx,my,mz)))
end

gAllMirRotCombos = GetAllMirRotCombos()


--! @brief random position with distance to point
--! @param dist number, distance between random point and point
--! @param x,y,z vector, "base" point
--! @return x,y,z vector
function GetRandomPositionAtDist (dist,x,y,z) 
	local ax,ay,az = Vector.random3(dist)
	return Vector.add(x,y,z,Vector.normalise_to_len(ax,ay,az,dist))
end

--! @brief is point2 in 2d rect
--! @param l,t vector2, left, top
--! @param r,b vector2, right, bottom
--! @param x,y vector2
--! @return true if inside, but not on bottom or right
function PointInRect	(l,t,r,b,x,y) 
	return x >= l and y >= t and x < r and y < b 
end

--! @brief combined to rects into minAABB containing both
--! @param la,ta,ra,ba rect2 a
--! @param lb,tb,rb,bb rect2 b
--! @param l,t,r,b rect2
function MergeRect	(la,ta,ra,ba, lb,tb,rb,bb) 
	return max(la,lb),max(ta,tb),min(ra,rb),min(ba,bb) 
end

function robmod (a,b) 
	while (a >= b) do a = a-b end
	return a
end

--! @briefe linear mapping from one interval to another
--! @param srcX value to map from src to dst
--! @param src0 src min border
--! @param src1 src max border
--! @param dst0 dst min border
--! @param dst1 dst max border
--! @return number value in dst interval
function MapFromTo (srcX, src0, src1, dst0, dst1)
	local r = (srcX - src0) / (src1 - src0)
	return dst0 + Clamp(r, 0,1) * (dst1 - dst0)
end
