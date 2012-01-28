cScreenMenu = {}

function cScreenMenu:LoadData ()
	gScreenImage_Menu = getCachedPaddedImage("data/title01.png")
end

function cScreenMenu:Start ()
	gCurrentScreen = this
end
