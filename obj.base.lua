cObjBase = CreateClass()
gGameObjects = {}
gGameObjects_New = {} -- delayed insert to avoid iterator corruption

gGfxOffX = {}
gGfxOffY = {}

function Objects_InitLayerOrder (arr)
	gGameObjectsLayerOrder = arr
	for k,layername in ipairs(gGameObjectsLayerOrder) do gGameObjects[layername] = {} end
	for k,layername in ipairs(gGameObjectsLayerOrder) do gGameObjects_New[layername] = {} end
end

function Objects_DestroyAll ()
	Objects_DelayedInsert()
	for k,layername in ipairs(gGameObjectsLayerOrder) do 
		for o,v in pairs(gGameObjects[layername]) do o:Destroy() end
		gGameObjects[layername] = {}
		gGameObjects_New[layername] = {}
	end
end

-- used for draw
function Objects_ForEachInLayerOrder (fun) 
end
function Objects_Draw () 
	draw.setWhite()
	for k,layername in ipairs(gGameObjectsLayerOrder) do 
		for o,v in pairs(gGameObjects[layername]) do 
			o:Draw()
		end
	end
end

function Objects_Step (dt)
	assert(dt)
	for layer,arr in pairs(gGameObjects) do for o,v in pairs(arr) do o:Step(dt) end end
	Objects_DelayedInsert()
end



function frand (a,b) return a + (b-a)*math.random() end

function Objects_DelayedInsert ()
	-- delayed insert new objects to avoid invalidating iterator during mainstep
	for layer,arr in pairs(gGameObjects_New) do 
		for o,v in pairs(arr) do 	
			gGameObjects[layer][o] = true
			gGameObjects_New[layer][o] = nil
		end
	end
end


--~ function cObjBase:ApplyImpulse ()
function cObjBase:onDestroy ()
	if (self.phys_shape) then self.phys_shape:destroy() self.phys_shape = nil end
	if (self.phys_body) then self.phys_body:destroy() self.phys_body = nil end
end

function cObjBase:Register		(layer) 
	gGameObjects_New[layer][self] = true           
	self.layer = layer 
	self.vx = self.vx or 0 
	self.vy = self.vy or 0 
end
function cObjBase:DeRegister		()		gGameObjects[self.layer][self] = nil self.bDead = true end
function cObjBase:Destroy			()		self:DeRegister() if (self.onDestroy) then self:onDestroy() end end
function cObjBase:ClipPosToScreen	()
	--~ local b = self.r or 0
	--~ self.x = max(b,min(gScreenW-b,self.x))
	--~ self.y = max(b,min(gScreenH-b,self.y))
end


	
function cObjBase:CheckDespawn	()
	if (gCamX - self.x > gObjectDespawnDist) then 
		print("CheckDespawn killed:",self:GetObjTypeName())
		self:Destroy()
	end
end
function cObjBase:NotifyPhysContact	(o)	 end
function cObjBase:GetObjTypeId		()		return kObjType_Unknown end
function cObjBase:GetObjTypeName	()		return kObjType2Txt[self:GetObjTypeId()] end
function cObjBase:Step			()		end
function cObjBase:SqDistToPos	(x,y)	local dx,dy = x-self.x,y-self.y return dx*dx + dy*dy end 
function cObjBase:DistToPos		(x,y)	local dx,dy = x-self.x,y-self.y return math.sqrt(dx*dx + dy*dy) end 
function cObjBase:DistToObj		(o)		return self:DistToPos(o.x,o.y) end 
function cObjBase:VectorToPos	(x,y)	return x-self.x,y-self.y end 
function cObjBase:VectorToObj	(o)		return self:VectorToPos(o.x,o.y) end 
function cObjBase:StepCollision	() end

function cObjBase:DistSmaller	(o,r)		
	local dx = self.x-o.x
	local dy = self.y-o.y
	return dx*dx + dy*dy <= r*r
end

function cObjBase:DrawDebug () end

function cObjBase:Draw ()
	local gfx = self.gfx
	if (not gfx) then return end 
	--~ print("cObjBase:Draw",type(gfx),gfx)
	local r = self.r or 0
	local sx,sy = 1,1
	local ox,oy = self.ox or gGfxOffX[gfx] or 0, self.oy or gGfxOffY[gfx] or 0
	love.graphics.draw(gfx,  math.floor(-gCamX + self.x),  math.floor(-gCamY + self.y), r, sx,sy, ox,oy) -- x, y, r, sx, sy, ox, oy
	
	-- debug : draw center
	if gShowDebug then 
		self:DrawDebug() 
		love.graphics.draw(gImgDot, -gCamX + self.x, -gCamY + self.y, r, sx,sy, -1,-1) -- x, y, r, sx, sy, ox, oy
	end
end


function KillAllObjectsOnLayer (layer) 
	for obj,v in pairs(gGameObjects[layer]) do obj:Destroy() end 
	for obj,v in pairs(gGameObjects_New[layer]) do obj:Destroy() end 
end
function IsObjectLayerEmpty (layer) 
	for obj,v in pairs(gGameObjects[layer]) do return false end 
	for obj,v in pairs(gGameObjects_New[layer]) do return false end 
	return true
end
function CountLayerItems (layer) 
	local c = 0 
	for obj,v in pairs(gGameObjects[layer]) do c = c + 1 end 
	for obj,v in pairs(gGameObjects_New[layer]) do c = c + 1 end 
	return c
end
function SumLayerItems (layer,fun) 
	local c = 0 
	for obj,v in pairs(gGameObjects[layer]) do c = c + fun(obj) end 
	for obj,v in pairs(gGameObjects_New[layer]) do c = c + fun(obj) end 
	return c
end

function PhysExplosionToAll(x,y,r,impulse)
	for layer,arr in pairs(gGameObjects		) do for obj,v in pairs(arr) do obj:ApplyExplosion(x,y,r,impulse) end end
	for layer,arr in pairs(gGameObjects_New	) do for obj,v in pairs(arr) do obj:ApplyExplosion(x,y,r,impulse) end end
end

function cObjBase:ApplyExplosion(x,y,r,impulse)
	local body = self.phys_body
	if (not body) then return end
	local d = self:DistToPos(x,y)
	if (d > r) then return end
	local dx,dy = self.x-x,self.y-y
	local f = impulse/max(0.001,math.sqrt(dx*dx+dy*dy))
	body:applyImpulse(dx*f,dy*f)
end

function FindNearestLayerObjectToObj (layer,o,maxrange,skip) return FindNearestLayerObject(layer,o.x,o.y,maxrange,skip) end
function FindNearestLayerObject (layer,x,y,maxrange,skip)
	local curd
	local curo
	local maxrange_square = maxrange and maxrange*maxrange
	for obj,v in pairs(gGameObjects[layer]) do 
		local d = obj:SqDistToPos(x,y)
		if ((not maxrange) or d <= maxrange_square) then 
		if (((not curd) or d < curd) and skip ~= obj) then curd = d curo = obj end 
		end
	end
	return curo,curo and math.sqrt(curd)
end

