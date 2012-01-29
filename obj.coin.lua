kPlayerCoinCollectRadius = 40


gCoinAnimation = nil
gCoins = {}
kCoinPropability = 4

gCoinsCollected = 0

function CoinInit()
	local gImgCoin = getCachedPaddedImage("data/coins.png")
	gCoinAnimation = newAnimation(gImgCoin, 64, 64, 0.02, 0)
	local coinsList = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta, kTileType_Coin)
	for k, v in pairs(coinsList) do
		gCoins[{x=v.x*kTileSize, y=v.y*kTileSize}] = true
	end
	--gCoins = TiledMap_ListAllOfTypeOnLayer(kMapLayer_Meta, kTileType_Enemy_Type1)
end

function CoinUpdate(dt)
	gCoinAnimation:update(dt)
end

function CoinDraw()
	for	k, v in pairs(gCoins) do
		if (v == true) then
			gCoinAnimation:draw(k.x+gCamAddX, k.y+gCamAddY, 0, 1,1, 0, 0)
		end
	end
end

function CheckCoinCollision(posX, posY)
	for k, v in pairs(gCoins) do
		if (gCoins[k] == true) then
			local coinMidX = k.x + kTileSize / 2
			local coinMidY = k.y + kTileSize / 2
			local posXPow = math.pow(posX-coinMidX,2)
			local posYPow = math.pow(posY-coinMidY,2)
			local	distance = math.sqrt(posXPow + posYPow)
			if (distance < (kTileSize / 2 + kPlayerCoinCollectRadius)) then
				gCoins[k] = false
				gCoinsCollected = gCoinsCollected + 1
				kPointsPlayer = kPointsPlayer + 10000
				playSFX(gCoinSound)
			end
		end
	end
end

function RespawnCoins()
	for k, v in pairs(gCoins) do
		if gCoins[k] == false and math.random(kCoinPropability) == 1 then
			gCoins[k] = true
		end
	end
	
end
