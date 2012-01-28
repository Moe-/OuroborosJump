cScreenGameOver = {}

function cScreenGameOver:LoadData ()
	self.bgimg		= getCachedPaddedImage("data/gameover01.png")
end

function cScreenGameOver:Start ()
	gCurrentScreen = self
end


function cScreenGameOver:draw( ) love.graphics.draw(self.bgimg,0,0) end
