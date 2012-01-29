cScreenMenu = {}

function cScreenMenu:LoadData ()
	self.bgimg = getCachedPaddedImage("data/title01.png")
end

function cScreenMenu:Start ()
	gCurrentScreen = self
	self.endt = gMyTime + 1.0
end

function cScreenMenu:update( ) if (gMyTime > self.endt) then self:StartGame() end end
function cScreenMenu:draw( ) love.graphics.draw(self.bgimg,0,0) end

function cScreenMenu:StartGame(  ) cScreenGame:Start() end
function cScreenMenu:keypressed( key, unicode ) self:StartGame() end
function cScreenMenu:mousepressed( x, y, button ) self:StartGame()  end
function cScreenMenu:joystickpressed() self:StartGame()  end
