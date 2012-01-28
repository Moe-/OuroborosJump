
gCoinAnimation = nil
gCoins = {}

function CoinInit()
	local gImgCoin = getCachedPaddedImage("data/coins.png")
	gCoinAnimation = newAnimation(gImgCoin, 64, 64, 0.02, 0)
	print("TileType ", kTileType_Coin)
	gCoins = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta, kTileType_Coin)
	--gCoins = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta, kTileType_Enemy_Type1)
	print("Found number of Coins in map: ", #gCoins)

	for k,v in pairs(gCoins) do
		gCoins[k].x = gCoins[k].x * kTileSize;
		gCoins[k].y = gCoins[k].y * kTileSize;
	end
end

function CoinUpdate(dt)
	gCoinAnimation:update(dt)
end

function CoinDraw()
	for	k, v in pairs(gCoins) do
		gCoinAnimation:draw(gCoins[k].x+gCamAddX, gCoins[k].y+gCamAddY, 0, 1,1, 0, 0)
	end
end

function CheckCoinCollision(posX, posY)

end
