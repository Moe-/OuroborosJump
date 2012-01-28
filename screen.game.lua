cScreenMenu = {}


function cScreenGame:LoadData	() end
function cScreenGame:Start		()
	gCurrentScreen = this
	GameInit()
end

function cScreenGame:keypressed( key, unicode ) 
	if key == "f5" then CheatShowMapMetaData() end
	if key == "up" or key == "w" then
		keyboard[kUp] = 1
	end
	if key == "down" or key == "s" then
		keyboard[kDown] = 1
	end
	if key == "left" or key == "a" then
		keyboard[kLeft] = 1
	end
	if key == "right" or key == "d" then
		keyboard[kRight] = 1
	end
end

function cScreenGame:keyreleased( key, unicode )
	gMyKeyPressed[key] = false
	if key == "up" or key == "w" then
		keyboard[kUp] = 0
	end
	if key == "down" or key == "s" then
		keyboard[kDown] = 0
	end
	if key == "left" or key == "a" then
		keyboard[kLeft] = 0
	end
	if key == "right" or key == "d" then
		keyboard[kRight] = 0
	end
end


function cScreenGame:mousepressed( x, y, button )
	DebugMouseClick(x,y,button)
	if button == "r" then gPlayer.x = x - gCamAddX  gPlayer.y = y - gCamAddY end
end


function cScreenGame:draw( )
	GameDraw()

	--~ if (button.drawAndCheckIfClicked(10, 10, "data/button/button_text_help.png")) then
		--~ print("click help")
	--~ end
end

function cScreenGame:update( dt )
	GameStep(dt)
end