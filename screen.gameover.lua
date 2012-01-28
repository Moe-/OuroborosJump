cScreenGameOver = {}

function cScreenGameOver:LoadData ()
	gScreenImage_GameOver		= getCachedPaddedImage("data/gameover01.png")
end

function cScreenGameOver:Start ()
	gCurrentScreen = this
end

