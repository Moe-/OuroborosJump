-- class.tiledMap.lua

--! class definition
cTiledMap = CreateClass()

--! @brief constructor
function cTiledMap:Init (filename)
	self.filename = filename
	self.basepath = basepath(filename)
	self.rootNode = nil
	
	self.widthInTiles = nil
	self.heightInTiles = nil
	self.tileWidthInPx = nil
	self.tileHeightInPx = nil
	self.ortientation = nil
	
	-- name value map
	self.properties = {}

	-- example tileset struct
	-- { firstgid = , lastgid = , name = , tileWidthInPx = , tileHeightInPx = , 
	-- 	imageSource = , imageWidthInPx = , imageHeightInPx = , imageTansparencyRGB = {r,g,b} }
	self.tilesets = {}
	
	-- example layer struct
	--  { name = , widthInTiles = , heightInTiles = , properties = {...} , data = {...} , }
	self.layers = {}
	
	-- example objectgroup struct
	-- { name = , objectType = , xInPx = , yInPx = , widthInPx = , heightInPx = , properties = {...}, gid = }
	self.objectgroups = {}
end

function cTiledMap:parseTilesetNode (node)
	local imageNode = Xml.oneNodeByXpath(node, "/image")
		
 --~ <tileset firstgid="1" name="testTiles" tilewidth="32" tileheight="32">
  --~ <image source="../gfx/testTiles.png" width="256" height="256"/>
 --~ </tileset>
 
	local defaultTransparencyHex = "ff00ff"
	local r,g,b = hex2rgb(imageNode["xarg"]["trans"] or defaultTransparencyHex)
 
	local tileset = {
		firstgid = tonumber(node["xarg"]["firstgid"]), 
		name = node["xarg"]["name"], 
		tileWidthInPx = tonumber(node["xarg"]["tilewidth"]), 
		tileHeightInPx = tonumber(node["xarg"]["tileheight"]), 
		imageSource = normalisePath(self.basepath .. imageNode["xarg"]["source"]), 
		imageWidthInPx = tonumber(imageNode["xarg"]["width"]), 
		imageHeightInPx = tonumber(imageNode["xarg"]["height"]), 
		imageTansparencyRGB = {r,g,b}, 
	}

	local w = tileset["imageWidthInPx"] / tileset["tileWidthInPx"]
	local h = tileset["imageHeightInPx"] / tileset["tileHeightInPx"]
	local tiles = w * h
	tileset["lastgid"] = tileset["firstgid"] + tiles - 1

	return tileset
end

function cTiledMap:parseObjectGroupNode (node)
 --~ <objectgroup name="character" width="100" height="100">
  --~ <object name="p1" type="player" x="128" y="320" width="32" height="32"/>
  --~ <object name="e3" type="enemy" x="768" y="416" width="32" height="32"/>
 --~ </objectgroup>
 --~ <objectgroup name="item" width="100" height="100">
  --~ <object gid="188" x="173" y="120"/>
  --~ <object gid="188" x="208" y="120"/>
 --~ </objectgroup>	
 
	local objectgroup = {
		name = node["xarg"]["name"], 
		widthInTiles = tonumber(node["xarg"]["width"]), 
		heightInTiles = tonumber(node["xarg"]["height"]), 
		objects = {},
	}
	
	local objects = Xml.xpath(node, "/object")
	for path, objectNode in pairs(objects) do
		-- parse properties
		local propertiesNode = Xml.oneNodeByXpath(objectNode, "/properties")
		local properties = propertiesNode and self:parsePropertiesNode(propertiesNode) or {}
		
		local gid, w, h, px, py
		
		if objectNode["xarg"]["gid"] then
			-- object from tileset
			gid = tonumber(objectNode["xarg"]["gid"])
			local imageFile, x, y, tileW, tileH, imageW, imageH = self:getImageDataFromGid(gid)
			w = tileW
			h = tileH
			px = tonumber(objectNode["xarg"]["x"])
			-- tiled items have a strange 1-off-in-y-axis effect
			py = tonumber(objectNode["xarg"]["y"]) - h
		else
			gid = nil
			w = tonumber(objectNode["xarg"]["width"])
			h = tonumber(objectNode["xarg"]["height"])
			px = tonumber(objectNode["xarg"]["x"])
			py = tonumber(objectNode["xarg"]["y"])
		end
		
		local object = {
			name = objectNode["xarg"]["name"], 
			objectType = objectNode["xarg"]["type"], 
			xInPx = px, 
			yInPx = py, 
			widthInPx = w, 
			heightInPx = h, 
			gid = gid,
			properties = properties,
		}

		table.insert(objectgroup.objects, object)
	end
	
	return objectgroup
end

function cTiledMap:parseLayerNode (node)
	-- parse properties
	local propertiesNode = Xml.oneNodeByXpath(node, "/properties")
	local properties = propertiesNode and self:parsePropertiesNode(propertiesNode) or {}

	-- parse data (currently only csv support)
	local dataNode = Xml.oneNodeByXpath(node, "/data[@encoding=csv]")
	local data = map(function(key, value) return tonumber(value) end, str.split(",", dataNode[1]))

--~ <layer name="ground" width="100" height="100">
  --~ <properties>
   --~ <property name="layerProp1" value="lulu"/>
  --~ </properties>
  --~ <data encoding="csv">
--~ 117,113,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,113,116,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,
--~ 111,112,74,74,74,74,74,74,74,74,74,74,74,74,74,74,74,74,74,128,74,74,74,74,74,74,74,74,74,111,112,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,

	local layer = {
		name = node["xarg"]["name"], 
		widthInTiles = tonumber(node["xarg"]["width"]), 
		heightInTiles = tonumber(node["xarg"]["height"]), 
		properties = properties,
		data = data
	}
	
	return layer
end

-- func: fun(name, objectType, xInPx, yInPx, widthInPx, heightInPx, properties, gid) => void
function cTiledMap:visitObjectGroupData (name, func)
	for k, objectgroup in pairs(self.objectgroups) do
		if objectgroup["name"] == name then
			for kk, object in pairs(objectgroup.objects) do
				func(object["name"], object["objectType"], object["xInPx"], object["yInPx"], 
					object["widthInPx"], object["heightInPx"], object["properties"], object["gid"])
				end
		end
	end
end

-- func: fun(screenX, screenY, imageFile, imageTileX, imageTileY, tileW, tileH, imageWidth, imageHeight) => void
function cTiledMap:visitLayerRenderData (name, func)
	self:visitLayerTileData(name, function(tx, ty, gid)
		-- skip invisible tiles
		if gid and gid > 0 then
			local imageFile, imageTileX, imageTileY, tileW, tileH, imageWidth, imageHeight = self:getImageDataFromGid(gid)
			func(tx * tileW, ty * tileH, imageFile, imageTileX, imageTileY, tileW, tileH, imageWidth, imageHeight)
		end
	end)
end

-- func: fun(tileX, tileY, gid) => void
function cTiledMap:visitLayerTileData (name, func)
	for k, layer in pairs(self.layers) do
		if layer["name"] == name then
			local tw = layer["widthInTiles"]
			local th = layer["heightInTiles"]
			local data = layer["data"]
			
			for tx = 0, tw - 1 do
			for ty = 0, th - 1 do
				local index = ty * tw + tx + 1
				func(tx, ty, data[index])
			end
			end
		end
	end
end

function cTiledMap:getLayerByName(layerName)
	for k, layer in pairs(self.layers) do
		if layer["name"] == name then
			return layer
		end
	end
end

function cTiledMap:getGidAtPixelXY(layerName, x, y)
	local tx = math.floor(x / self.tileWidthInPx)
	local ty = math.floor(y / self.tileHeightInPx)
	
	return self:getGidAtTileXY(tx, ty)
end

function cTiledMap:getGidAtTileXY(layerName, tileX, tileY)
	local layer = self:getLayerByName(layerName)

	if layer then
		local tw = layer["widthInTiles"]
		local th = layer["heightInTiles"]
		local data = layer["data"]
		
		local index = tileY * tw + tileX + 1
		return data[index]
	end
	
	return nil
end

--! @return imageFile, x, y, tileW, tileH, imageW, imageH
function cTiledMap:getImageDataFromGid (gid)
	if self.imageDataCache and self.imageDataCache[gid] then 
		return unpack(self.imageDataCache[gid])
	end
	
	for _, tileset in pairs(self.tilesets) do
		if gid >= tileset["firstgid"] and gid <= tileset["lastgid"] then
			local localGid = gid - tileset["firstgid"]
			
			local tilesOnX = tileset["imageWidthInPx"] / tileset["tileWidthInPx"]
			local tx = math.mod(localGid, tilesOnX)
			local ty = math.floor(localGid / tilesOnX)
			
			imageFile = tileset["imageSource"]
			tw = tileset["tileWidthInPx"]
			th = tileset["tileHeightInPx"]
			iw = tileset["imageWidthInPx"]
			ih = tileset["imageHeightInPx"]
			x = tx * tw
			y = ty * th
		end
	end
	
	self.imageDataCache = self.imageDataCache or {}
	self.imageDataCache[gid] = {imageFile, x, y, tw, th, iw, ih}
	
	return imageFile, x, y, tw, th, iw, ih
end

function cTiledMap:parsePropertiesNode (propertiesNode)
	local props = {}
	
	if propertiesNode then
		local propNodes = Xml.xpath(propertiesNode, "/property")
		for path, node in pairs(propNodes) do
			props[node["xarg"]["name"]] = node["xarg"]["value"]
		end
	end
	
	return props
end

function cTiledMap:load ()
	self.rootNode = Xml.collect(love.filesystem.read(self.filename))
	
	local generalInfo = Xml.oneNodeByXpath(self.rootNode, "/map")
	
	-- general map info
	self.widthInTiles = generalInfo["xarg"]["width"]
	self.heightInTiles = generalInfo["xarg"]["height"]
	self.tileWidthInPx = generalInfo["xarg"]["tilewidth"]
	self.tileHeightInPx = generalInfo["xarg"]["tileheight"]
	self.ortientation = generalInfo["xarg"]["orientation"]
	
	-- load general properties
	self.properties = self:parsePropertiesNode(Xml.oneNodeByXpath(self.rootNode, "/map/properties"))
		
	-- load tilesets
	local tilesets = Xml.xpath(self.rootNode, "/map/tileset")
	for path, node in pairs(tilesets) do
		table.insert(self.tilesets, self:parseTilesetNode(node))
	end
	
	-- load layers
	local layers = Xml.xpath(self.rootNode, "/map/layer")
	for path, node in pairs(layers) do
		table.insert(self.layers, self:parseLayerNode(node))
	end	
	
	-- load objectgroups
	local objectgroups = Xml.xpath(self.rootNode, "/map/objectgroup")
	for path, node in pairs(objectgroups) do
		table.insert(self.objectgroups, self:parseObjectGroupNode(node))
	end	
end

function cTiledMap:dump ()
	--~ Xml.pathdump(self.rootNode)
	
	for gid = 1,100 do print(self:getImageDataFromGid(gid)) end
end
