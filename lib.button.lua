
button = {}

button._path_to_normal = "data/button/button_normal.png"
button._path_to_hover = "data/button/button_hover.png"
button._path_to_active = "data/button/button_active.png"

local function isMouseInsideButtonAt(button_x, button_y)
	local l,t = button_x, button_y
	local img = getCachedPaddedImage(button._path_to_normal)
	local r,b = l + img:getWidth(), t + img:getHeight()
	
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	
	return PointInRect(l, t, r, b, mx, my) 
end

button.draw = function (x,y, path_to_text_image_file)
	local inside = isMouseInsideButtonAt(x,y)
	local clicked = love.mouse.isDown("l")
	
	local buttonImg = getCachedPaddedImage(button._path_to_normal)
	if inside and clicked then
		buttonImg = getCachedPaddedImage(button._path_to_active)
	elseif inside then
		buttonImg = getCachedPaddedImage(button._path_to_hover)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(buttonImg, x, y)
	love.graphics.draw(getCachedPaddedImage(path_to_text_image_file), x, y)
end

local buttonWasDownLastCheck = {}

button.drawAndCheckIfClicked = function (x,y, path_to_text_image_file)
	local isGoingUp = false
	
	local key = x .. "_" .. y
	if buttonWasDownLastCheck[key] and love.mouse.isDown("l") == false then
		isGoingUp = true
	end

	if love.mouse.isDown("l") then 
		buttonWasDownLastCheck[key] = true
	else
		buttonWasDownLastCheck[key] = false
	end

	button.draw(x,y, path_to_text_image_file)
	return isMouseInsideButtonAt(x,y) and isGoingUp
end
