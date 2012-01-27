-- class.aStar.lua

local PriorityQueue = require "loop.collection.PriorityQueue"
	
--! class definition
cAStar = CreateClass()

--! @brief constructor
function cAStar:Init (collisionGrid)
	self.collisionGrid = collisionGrid
end

function cAStar:posFromKey (key)
	local x,y = unpack(str.split("_", key))
	return x,y
end

function cAStar:posKey (x,y)
	return x .. "_" .. y
end

function cAStar:heuristic_cost_estimate (startX, startY, endX, endY)
	return ((startX - endX)^2 + (startY - endY)^2)^0.5
end


function cAStar:getNeighborsFromIndex(index)
	local x,y = self:posFromKey(index)
	
	local neighbors = {}
	
	for dx = -1,1 do
	for dy = -1,1 do
		-- skip center
		if (dx ~= 0 or dy ~= 0) and not self.collisionGrid:getXY(x+dx,y+dy) then
			table.insert(neighbors, self:posKey(x+dx,y+dy))
		end
	end
	end
	
	return neighbors
end

function cAStar:movementcost (currentIndex, neighborIndex)
	return self:h(currentIndex, neighborIndex)
end

function cAStar:h (startIndex, endIndex)
	local sx,sy = self:posFromKey(startIndex)
	local ex,ey = self:posFromKey(endIndex)
	
	h_diagonal = min(abs(sx-ex), abs(sy-ey))
	h_straight = abs(sx-ex) + abs(sy-ey)
	
	return math.sqrt(2) * h_diagonal + (h_straight - 2 * h_diagonal)
end

function cAStar:findPath (fromX, fromY, toX, toY)
	local startIndex = self:posKey(fromX, fromY)
	local endIndex = self:posKey(toX, toY)
	
	-- OPEN = priority queue containing START
	local open = PriorityQueue()
	open:enqueue(startIndex, 0)
	
	-- CLOSED = empty set
	local closed = {}
	
	local parents = {}
	local cost_g = {}
	cost_g[startIndex] = 0
	
	-- while lowest rank in OPEN is not the GOAL:
	while not open:empty() and open:head() ~= endIndex do
		-- current = remove lowest rank item from OPEN
		local currentIndex = open:dequeue()
		-- add current to CLOSED
		closed[currentIndex] = true
		
		--~ print("currentIndex",currentIndex)
		
		-- for neighbors of current:
		local neighbors = self:getNeighborsFromIndex(currentIndex)
		for k,neighborIndex in pairs(neighbors) do
			--~ print("neighborIndex", neighborIndex)
			-- cost = g(current) + movementcost(current, neighbor)
			local cost = cost_g[currentIndex] + self:movementcost(currentIndex, neighborIndex)
		
			-- if neighbor in OPEN and cost less than g(neighbor):
			if open:contains(neighborIndex) and cost < cost_g[neighborIndex] then
				-- remove neighbor from OPEN, because new path is better
				open:remove(neighborIndex)
			end
		
			-- if neighbor in CLOSED and cost less than g(neighbor): **
			if closed[neighborIndex] and cost < cost_g[neighborIndex] then
				-- remove neighbor from CLOSED
				closed[neighborIndex] = nil
			end
		  
			-- if neighbor not in OPEN and neighbor not in CLOSED:
			if not open:contains(neighborIndex) and not closed[neighborIndex] then
				-- set g(neighbor) to cost
				cost_g[neighborIndex] = cost
				-- add neighbor to OPEN
				-- set priority queue rank to g(neighbor) + h(neighbor)
				open:enqueue(neighborIndex, cost + self:h(neighborIndex, endIndex))
				-- set neighbor's parent to current
				parents[neighborIndex] = currentIndex
			end
		end
	end
	
	if open:empty() then
		-- no path found
		return nil
	else
		local currentIndex = open:head()
		-- reconstruct reverse path from goal to start
		-- by following parent pointers
		
		local path = {}
		
		table.insert(path, {self:posFromKey(currentIndex)})
		while parents[currentIndex] do
			currentIndex = parents[currentIndex]
			table.insert(path, {self:posFromKey(currentIndex)})
		end
		
		return reverse_array(path)
	end
end
