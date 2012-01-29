cScreenMenu = {}

function cScreenMenu:LoadData ()
	self.bgimg = getCachedPaddedImage("data/title01.png")
end

function cScreenMenu:Start ()
	gCurrentScreen = self
end

function cScreenMenu:draw( ) love.graphics.draw(self.bgimg,0,0) end

function cScreenMenu:StartGame(  ) cScreenLevelSelect:Start() end
function cScreenMenu:keypressed( key, unicode ) self:StartGame() end
function cScreenMenu:mousepressed( x, y, button ) self:StartGame()  end
function cScreenMenu:joystickpressed() self:StartGame()  end
