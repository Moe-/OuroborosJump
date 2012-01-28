-- loader for "tiled" map editor maps (.tmx,xml-based) http://www.mapeditor.org/
-- supports multiple layers
-- NOTE : function ReplaceMapTileClass (tx,ty,oldTileType,newTileType,fun_callback) end
-- NOTE : function TransmuteMap (from_to_table) end -- from_to_table[old]=new
-- NOTE : function GetMousePosOnMap () return gMouseX+gCamX-gScreenW/2,gMouseY+gCamY-gScreenH/2 end

kTileSize = 64
kMapTileTypeEmpty = 0
local floor = math.floor
local ceil = math.ceil
local max = math.max
local min = math.min
local abs = math.abs
gTileMap_LayerInvisByName = {}

function TiledMap_Load (filepath,tilesize,spritepath_removeold,spritepath_prefix)
    spritepath_removeold = spritepath_removeold or "../"
    spritepath_prefix = spritepath_prefix or ""
    kTileSize = tilesize or kTileSize or 32
    gTileGfx = {}
   
    local tiletype,layers = TiledMap_Parse(filepath)
    gMapLayers = layers
    for first_gid,path in pairs(tiletype) do
        path = spritepath_prefix .. string.gsub(path,"^"..string.gsub(spritepath_removeold,"%.","%%."),"")
        local raw = love.image.newImageData(path)
        local w,h = raw:getWidth(),raw:getHeight()
        local gid = first_gid
        local e = kTileSize
        for y=0,floor(h/kTileSize)-1 do
        for x=0,floor(w/kTileSize)-1 do
            local sprite = love.image.newImageData(kTileSize,kTileSize)
            sprite:paste(raw,0,0,x*e,y*e,e,e)
            gTileGfx[gid] = love.graphics.newImage(sprite)
            gid = gid + 1
        end
        end
    end
end

function TiledMap_GetMapW () return gMapLayers.width end
function TiledMap_GetMapH () return gMapLayers.height end

-- returns the mapwidth actually used by tiles
function TiledMap_GetMapWUsed ()
	local maxx = 0
	for layerid,layer in pairs(gMapLayers) do 
		if (type(layer) == "table") then for ty,row in pairs(layer) do
			if (type(row) == "table") then for tx,t in pairs(row) do 
				if (t and t ~= kMapTileTypeEmpty) then 
					maxx = max(maxx,tx)
				end
			end end
		end end
	end
	return maxx + 1
end

-- x,y= position for nearest-distance(square,not round), z= layer, maxrad= optional limit for searching
-- returns x,y
-- if x,y can be far outside map, set a sensible maxrad, otherwise it'll get very slow since searching outside map isn't optimized
function TiledMap_GetNearestTileByTypeOnLayer (x,y,z,iTileType,maxrad)
	local w = TiledMap_GetMapW()
	local h = TiledMap_GetMapW()
	local maxrad2 = max(x,w-x,y,h-y) if (maxrad) then maxrad2 = min(maxrad2,maxrad) end
	if (TiledMap_GetMapTile(x,y,z) == iTileType) then return x,y end
	for r = 1,maxrad2 do 
		for i=-r,r do 
			local xa,ya = x+i,y-r if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- top
			local xa,ya = x+i,y+r if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- bot
			local xa,ya = x-r,y+i if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- left
			local xa,ya = x+r,y+i if (TiledMap_GetMapTile(xa,ya,z) == iTileType) then return xa,ya end -- right
		end
	end
end

function TiledMap_GetMapTile (tx,ty,layerid) -- coords in tiles
    local row = gMapLayers[layerid][ty]
    return row and row[tx] or kMapTileTypeEmpty
end

function TiledMap_SetMapTile (tx,ty,layerid,v) -- coords in tiles
    local row = gMapLayers[layerid][ty]
	if (not row) then row = {} gMapLayers[layerid][ty] = row end
	row[tx] = v
end

-- todo : maybe optimize during parse xml for types registered as to-be-listed before parsing ?
function TiledMap_ListAllOfTypeOnLayer (layerid,iTileType)
	local res = {}
	local w = TiledMap_GetMapW()
	local h = TiledMap_GetMapH()
	for x=0,w-1 do 
	for y=0,h-1 do 
		if (TiledMap_GetMapTile(x,y,layerid) == iTileType) then table.insert(res,{x=x,y=y}) end
	end
	end
	return res
end

function TiledMap_GetLayerZByName (layername) for z,layer in ipairs(gMapLayers) do if (layer.name == layername) then return z end end end
function TiledMap_SetLayerInvisByName (layername) gTileMap_LayerInvisByName[layername] = true end

function TiledMap_IsLayerVisible (z)
	local layer = gMapLayers[z]
	return layer and (not gTileMap_LayerInvisByName[layer.name or "?"])
end

function TiledMap_GetTilePosUnderMouse (mx,my,camx,camy)
	return	floor((mx+camx-love.graphics.getWidth()/2)/kTileSize),
			floor((my+camy-love.graphics.getHeight()/2)/kTileSize)
end

function TiledMap_DrawNearCam (camx,camy,fun_layercallback)
    camx,camy = floor(camx),floor(camy)
    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()
    local minx,maxx = floor((camx-screen_w/2)/kTileSize),ceil((camx+screen_w/2)/kTileSize)
    local miny,maxy = floor((camy-screen_h/2)/kTileSize),ceil((camy+screen_h/2)/kTileSize)
    for z = 1,#gMapLayers do 
	if (fun_layercallback) then fun_layercallback(z,gMapLayers[z]) end
	if (TiledMap_IsLayerVisible(z)) then
    for x = minx,maxx do
    for y = miny,maxy do
        local gfx = gTileGfx[TiledMap_GetMapTile(x,y,z)]
        if (gfx) then
            local sx = x*kTileSize - camx + screen_w/2
            local sy = y*kTileSize - camy + screen_h/2
            love.graphics.draw(gfx,sx,sy) -- x, y, r, sx, sy, ox, oy
        end
    end
    end
    end
    end
end


-- ***** ***** ***** ***** ***** xml parser


-- LoadXML from http://lua-users.org/wiki/LuaXml
function LoadXML(s)
  local function LoadXML_parseargs(s)
    local arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
    end)
    return arg
  end
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=LoadXML_parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=LoadXML_parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[stack.n].label)
  end
  return stack[1]
end


-- ***** ***** ***** ***** ***** parsing the tilemap xml file

local function getTilesets(node)
    local tiles = {}
    for k, sub in ipairs(node) do
        if (sub.label == "tileset") then
            tiles[tonumber(sub.xarg.firstgid)] = sub[1].xarg.source
        end
    end
    return tiles
end

local function getLayers(node)
    local layers = {}
	layers.width = 0
	layers.height = 0
    for k, sub in ipairs(node) do
        if (sub.label == "layer") then --  and sub.xarg.name == layer_name
			layers.width  = max(layers.width ,tonumber(sub.xarg.width ) or 0)
			layers.height = max(layers.height,tonumber(sub.xarg.height) or 0)
            local layer = {}
            table.insert(layers,layer)
			layer.name = sub.xarg.name
			--~ print("layername",layer.name)
            width = tonumber(sub.xarg.width)
            i = 0
            j = 0
            for l, child in ipairs(sub[1]) do
                if (j == 0) then
                    layer[i] = {}
                end
                layer[i][j] = tonumber(child.xarg.gid)
                j = j + 1
                if j >= width then
                    j = 0
                    i = i + 1
                end
            end
        end
    end
    return layers
end

function TiledMap_Parse(filename)
    local xml = LoadXML(love.filesystem.read(filename))
    local tiles = getTilesets(xml[2])
    local layers = getLayers(xml[2])
    return tiles, layers
end
