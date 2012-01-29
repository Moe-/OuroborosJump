cScreenMenu = {}

function cScreenMenu:LoadData ()
	self.bgimg = getCachedPaddedImage("data/title01.png")
	
	-- test particle sys
	createEnemyParticleSystems()
end

function cScreenMenu:Start ()
	gCurrentScreen = self
	--~ self.endt = gMyTime + 1.0
end

function cScreenMenu:update(dt) 
	if (self.endt and gMyTime > self.endt) then self:StartGame() end 
	CheatTestEnemyDieParticleOnPlayer_Update(dt) 
end
function cScreenMenu:draw( ) 
	love.graphics.draw(self.bgimg,0,0)
	CheatTestEnemyDieParticleOnPlayer_Draw() 
end

function cScreenMenu:StartGame(  ) cScreenGame:Start() end
function cScreenMenu:keypressed( key, unicode ) self:StartGame() end
function cScreenMenu:mousepressed( x, y, button ) self:StartGame()  end
function cScreenMenu:joystickpressed() self:StartGame()  end

function cScreenMenu:keypressed( key, unicode ) 
	if key == "f2" then CheatTestEnemyDieParticleOnPlayer(100,100) return end
	self:StartGame()
end