cScreenGameOver = {}

function cScreenGameOver:LoadData ()
	self.bgimg		= getCachedPaddedImage("data/gameover01.png")
end

function cScreenGameOver:Start ()
	gCurrentScreen = self
end


function cScreenGameOver:draw( ) love.graphics.draw(self.bgimg,0,0) end

function cScreenGameOver:BackToMenu(  ) cScreenMenu:Start() end
function cScreenGameOver:StartGame(  ) self:BackToMenu() end
function cScreenGameOver:keypressed( key, unicode ) self:BackToMenu() end
function cScreenGameOver:mousepressed( x, y, button ) self:BackToMenu()  end
