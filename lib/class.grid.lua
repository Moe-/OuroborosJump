-- class.grid.lua

--! class definition
cGrid = CreateClass()

--! @brief constructor
function cGrid:Init ()
	self.partW = 10
	self.partH = 10
	self.parts = {}
end

--! @brief remove the complete content
function cGrid:clear ()
	self.parts = {}
end

--! @brief receives grid cell content
--! @param x,y position
--! @return any or nil if empty
function cGrid:getXY (x, y)
	local part, position = self:getPartAndPositionWithinXY(x,y)
	if part then 
		return part[position]
	end
end

--! @brief set grid cell content
--! @param x,y position
--! @param any content, must not be nil
function cGrid:setXY (x, y, content)
	local part, position = self:ensurePartAndGetPositionWithinXY(x,y)
	part[position] = content
end

--! @brief rectangualr area visitor, calls a callback on each cell, order is not defined
--! @param x,y left top of area
--! @param w,h size of area
--! @param fun visitor function: function (x,y,content)
function cGrid:visitRect (x, y, w, h, fun)
	for ix = x, x + w, 1 do
	for iy = y, y + h, 1 do
		fun(ix,iy, self:getXY(ix,iy))
	end
	end
end

function cGrid:calculatePositionWithinPart (x,y)
	return 1 + math.floor(y / self.partW) + math.mod(x, self.partH)
end

function cGrid:getPartAndPositionWithinXY (x, y)
	local partKey = self:getPartKeyContainingXY(x,y)
	
	local part = self.parts[partKey]
	
	if part then
		return part, self:calculatePositionWithinPart(x,y)
	else
		return nil, nil
	end
end

function cGrid:getPartKeyContainingXY (x, y)
	return x .. "_" .. y;
end

function cGrid:ensurePartAndGetPositionWithinXY (x, y)
	local partKey = self:getPartKeyContainingXY(x,y)

	if not self.parts[partKey] then
		self.parts[partKey] = {}
	end

	return self:getPartAndPositionWithinXY(x,y)
end
