---------------------------------
--! @file
--! @brief Input handling stuff
---------------------------------

--! namespace
Input = {}


--! @brief converts the keyboard state to a movement vector, left -> -1,0, top -> -1,0
--! @param up, left, down, right love keynames
--! @return dx,dy 	vector2 [-1,1],[-1,1]
function Input.keysToDirectionVector (up, left, down, right)
	local dx,dy = 0,0
	
	if love.keyboard.isDown(up) then dy = -1 end
	if love.keyboard.isDown(down) then dy = 1 end
	if love.keyboard.isDown(left) then dx = -1 end
	if love.keyboard.isDown(right) then dx = 1 end
	
	return dx,dy
end