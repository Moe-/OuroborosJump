-- class.objectPool.lua

--! class definition
cObjectPool = CreateClass()

function cObjectPool:Init ()
	self.objects = {}
end

function cObjectPool:count ()
	return countarr(self.objects)
end 

function cObjectPool:callOnAll(methodName, ...)
	for obj,v in pairs(self.objects) do
		if obj[methodName] and type(obj[methodName]) == "function" then
			obj[methodName](obj, ...)
		end
	end
end

-- fun: function(object)
function cObjectPool:visit (fun)
	for obj,v in pairs(self.objects) do
		fun(obj)
	end
end

function cObjectPool:update (...)
	self:callOnAll("update", ...)
end	

function cObjectPool:draw (...)
	self:callOnAll("draw", ...)
end

function cObjectPool:add (obj)
	self.objects[obj] = true
end

function cObjectPool:del (obj)
	self.objects[obj] = nil
end

function cObjectPool:clear ()
	self.objects = {}
end
