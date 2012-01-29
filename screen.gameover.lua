cScreenGameOver = {}

function cScreenGameOver:LoadData ()
	self.bgimg		= getCachedPaddedImage("data/gameover01.png")
end

function cScreenGameOver:Start ()
	gCurrentScreen = self
	table.sort(gHighScore,function (a,b) 
		local _,_,score1 = string.find(a,"(%d+)$")
		local _,_,score2 = string.find(b,"(%d+)$")
		return (score1 and tonumber(score1) or 0) > (score2 and tonumber(score2) or 0)
	end)
	for k,line in ipairs(gHighScore) do 
		print("gameover-hiscore",k,line)
	end
end


function cScreenGameOver:draw( )

	love.graphics.draw(self.bgimg,0,0)
	
	for i=1,min(#gHighScore,10) do
		local line = gHighScore[i]
		local _,_,score1 = string.find(line,"(%d+)$")
		local ptxt = TausenderTrenner(max(0,score1 or 0))
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(gMyFont)
		love.graphics.print("#"..i..": " .. ptxt, 50+30, 200+ 50*i)
		love.graphics.setColor(255, 0, 0)
		love.graphics.print("#"..i..": " .. ptxt, 50+26, 200+ 50*i)
		love.graphics.setColor(255, 255, 255)
	end
end

function cScreenGameOver:BackToMenu(  ) cScreenMenu:Start() end
function cScreenGameOver:StartGame(  ) self:BackToMenu() end
function cScreenGameOver:keypressed( key, unicode ) self:BackToMenu() end
function cScreenGameOver:mousepressed( x, y, button ) self:BackToMenu()  end
function cScreenGameOver:joystickpressed() self:BackToMenu()  end
