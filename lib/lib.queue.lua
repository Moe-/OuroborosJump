---------------------------------
--! @file
--! @brief queue data structure
---------------------------------

--[[

local q = cQueue:New()

q:push(1)
q:push(2)
q:push(3)

print(q:isEmpty())
print(q:pop())
print(q:pop())
print(q:pop())
	
]]--

--! class definition
cQueue = CreateClass()

--! @brief constructor
function cQueue:Init ()
	self.first = 0
	self.last = -1
end

--! @brief adds value to the left end of the queue
--! @param value any
function cQueue:pushLeft (value)
	local first = self.first - 1
	self.first = first
	self[first] = value
end

--! @brief adds value to the right end of the queue
--! @param value any
function cQueue:push (value)
	self:pushRight(value)
end

--! @brief adds value to the right end of the queue
--! @param value any
function cQueue:pushRight (value)
	local last = self.last + 1
	self.last = last
	self[last] = value
end

--! @brief pops the left most element from the queue, 
--! only call if there is at least one element in the queue
--! @return any
function cQueue:pop ()
	return self:popLeft()
end

--! @brief pops the left most element from the queue, 
--! only call if there is at least one element in the queue
--! @return any
function cQueue:popLeft ()
	local first = self.first
	
	if first > self.last then error("self is empty") end
	
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1
	
	return value
end

--! @brief pops the right most element from the queue, 
--! only call if there is at least one element in the queue
--! @return any
function cQueue:popRight ()
	local last = self.last
	
	if self.first > last then error("self is empty") end
	
	local value = self[last]
	self[last] = nil         -- to allow garbage collection
	self.last = last - 1
	
	return value
end

--! @brief checks if the queue is empty
--! @return bool true if there is no element
function cQueue:isEmpty ()
	return self.first > self.last
end

--! @brief visitor, fun = function(value)
function cQueue:visit (fun)
	if self:isEmpty() then return end
	
	for i=self.first, self.last do
		fun(self[i])
	end
end
