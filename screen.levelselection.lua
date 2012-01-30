cScreenLevelSelect = {}

gLevelImages = {}
gCurrentLevel = 1

kMaxLevels = 2

kArrowWidth = 163
kArrowDistanceToBorder = 10

gArrows = {}

gEventCountdown = 0
kSecondsTillNextEvent  = 0.5

gLevelFont = love.graphics.newFont( "data/Ascension_0.ttf", 80 ) or love.graphics.newFont( 48 )

function cScreenLevelSelect:LoadData()
	local i = 1
	while (love.filesystem.exists("data/level" .. i .. ".png")) do
		gLevelImages[i] = getCachedPaddedImage("data/level" .. i .. ".png")
		i = i+1
	end
	print("gLevelImageSize " .. #gLevelImages)
	gArrows[1] = getCachedPaddedImage("data/arrow_left.png")
	gArrows[2] = getCachedPaddedImage("data/arrow_right.png")
end

function cScreenLevelSelect:Start ()
	gCurrentScreen = self
  gEventCountdown = 0
end

function cScreenLevelSelect:draw( )
	local screen_w = love.graphics.getWidth()
  local screen_h = love.graphics.getHeight()

	love.graphics.draw(gLevelImages[gCurrentLevel], 0, screen_h/2 - 150)
	love.graphics.draw(gArrows[1], kArrowDistanceToBorder,screen_h/2 + 125 + 133/2)
	love.graphics.draw(gArrows[2], screen_w-kArrowDistanceToBorder - kArrowWidth, screen_h/2 + 125 + 133/2)

	love.graphics.setFont(gLevelFont)
	love.graphics.print("Level " .. gCurrentLevel, screen_w/2 - 180, 75)
end

-- offset: value of parameter by which we switch (negative values to the left, positive to the right)
function cScreenLevelSelect:switchLevel(offset)
	gCurrentLevel = (gCurrentLevel + offset - 1) % kMaxLevels + 1
end

function cScreenLevelSelect:BackToMenu(  ) cScreenMenu:Start() end
function cScreenLevelSelect:StartGame(  ) cScreenGame:Start() end

function cScreenLevelSelect:keypressed( key, unicode )
	if key == "left" or key == "a" then
		self:switchLevel(-1)
	end
	if key == "right" or key == "d" then
		self:switchLevel(1)
	end
	if key == " " then
		cScreenGame:Start() 
	end
end

function cScreenLevelSelect:mousepressed( x, y, button ) cScreenGame:Start()  end

function cScreenLevelSelect:joystickpressed() 
	if(love.joystick.getNumJoysticks( ) > 0) then
		leftRightAxis, upDownAxis = love.joystick.getAxes( joystick0 )
		if (leftRightAxis > joysticksensitivity) then
			self:switchLevel(-1)
		elseif (leftRightAxis < -joysticksensitivity) then
			self:switchLevel(1)
		else 
			cScreenGame:Start() 	
		end	
	end
end

function cScreenLevelSelect:update(dt)
	if(love.joystick.getNumJoysticks( ) > 0) then
		gEventCountdown = gEventCountdown - dt
		if (gEventCountdown < 0) then
			leftRightAxis, upDownAxis = love.joystick.getAxes( joystick0 )
			if (leftRightAxis > joysticksensitivity) then
				joystickaxes[kRight] = 1
				joystickaxes[kLeft] = 0
			elseif (leftRightAxis < -joysticksensitivity) then
				joystickaxes[kRight] = 0
				joystickaxes[kLeft] = 1
			else
				joystickaxes[kRight] = 0
				joystickaxes[kLeft] = 0
			end

			if joystickaxes[kLeft] == 1 and gLastEvent == kNeutral then
				self:switchLevel(-1)
				lastEvent = kLeft
			end
			if joystickaxes[kRight] == 1  and gLastEvent == kNeutral then
				self:switchLevel(1)
				lastEvent = kRight
			end
			gEventCountdown = kSecondsTillNextEvent
		end
	end
end
