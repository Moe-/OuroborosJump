
---------------------------------
--! @file
--! @brief 
---------------------------------

--! namespace
draw = {}

--! @brief draws a line given in local space at the base point
--! @param points {{x,y}, {x,y}, ...}
--! @param baseX, baseY root position
function draw.path (points, baseX, baseY)
	baseX = baseX or 0
	baseY = baseY or 0
	
	local count = 0
	
	line = {}
	
	for k,v in pairs(points) do
		local x,y = unpack(v)
		table.insert(line, x + baseX)
		table.insert(line, y + baseY)
		
		count = count + 1
	end
	
	if count > 1 then
		love.graphics.line(line)
	end
end

function draw.setWhite()
	love.graphics.setColor(255, 255, 255, 255)
end
