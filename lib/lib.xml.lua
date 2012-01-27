---------------------------------
--! @file
--! @brief utilities for xml
---------------------------------

--! namespace
Xml = {}

--! @brief prints xml structure
--! @param o table node from Xml.collect
--! @param L number depth
--! @return x,y,z vector, every coord is in [0,1)
function Xml.dump (o,L) 
	L = L or 0
	if (type(o) == "table") then
		printf("{\n")
		local k,v
		if (o.name) then printf(string.rep(" ",4*(L+1)).."name=%s\n",o.name) end
		for k,v in pairs(o) do if (k ~= "name" and k ~= "n") then
			printf(string.rep(" ",4*(L+1)).."%s=",k)
			Xml.dump(v,L+1)
		end end
		printf(string.rep(" ",4*L).."}\n")
	else
		printf("%s\n",""..o)
	end
end

--! @brief converts a simple xpath expression into a "regex" to math the path
--! @param xpathString string eg. /map
--! @return string eg. ^/map%[[^]]*%]$
function Xml.ConvertPseudoXPathToPathExpression(xpathString)
	-- called 2 times due to overlapping matching areas
	-- this way it replaces the parts alternating
	-- eg. /lala/lulu/bla - lulu would be skipped without the second call
	xpathString = string.gsub(xpathString, "/(%w+)/", "/%1[]/")
	xpathString = string.gsub(xpathString, "/(%w+)/", "/%1[]/")

	xpathString = string.gsub(xpathString, "/(%w+)$", "/%1[]")
	
	xpathString = string.gsub(xpathString, "//", ".*/")
	
	xpathString = string.gsub(xpathString, "%[([^],]+)%]", "%%[[^]]*%1[^]]*%%]")
	
	xpathString = string.gsub(xpathString, "%[%]", "%%[[^]]*%%]")
	
	xpathString = "^" .. xpathString .. "$"

	return xpathString
end

--! @brief finds nodes by simple xpath expression
--! @param rootNode table from Xml.collect
--! @param xpathExpression string eg. /map[@lala=1]
--! @return array {PATH=NODE, ...}
function Xml.xpath(rootNode, xpathExpression)
	return Xml.path(rootNode, Xml.ConvertPseudoXPathToPathExpression(xpathExpression))
end

--! @brief finds one node by simple xpath expression
--! @param rootNode table from Xml.collect
--! @param xpathExpression string eg. /map[@lala=1]
--! @return table NODE or nil on error
function Xml.oneNodeByXpath(rootNode, xpathExpression)
	local nodes = Xml.xpath(rootNode, xpathExpression)
	
	-- return first node
	for path, node in pairs(nodes) do
		return node
	end
	
	return nil
end

--! @brief finds nodes by "regex" path matching
--! @param rootNode table from Xml.collect
--! @param pathExpression string "regex" eg. map%[
--! @return array {PATH=NODE, ...}
function Xml.path(rootNode, pathExpression)
	local list = {}
	Xml.pathlist(rootNode, nil, list)
	
	list = filter(function (path, node) 
		local from, to = string.find(path, pathExpression)
		return from ~= nil
	end, list)
	
	return list
end

--! @brief prints all nodes path
--! @param rootNode table from Xml.collect
function Xml.pathdump(rootNode)
	local list = {}
	Xml.pathlist(rootNode, nil, list)
	
	for path, node in pairs(list) do
		print(path)
	end
end

--! @brief collects all nodes paths into list
--! @param node table from Xml.collect
--! @param path string [OPTIONAL] current parent path for recusion
--! @param list array [OUT] contains collected paths, {PATH=NODE, ...}
function Xml.pathlist(node, path, list)
	path = path or ""
	
	for index, childNode in pairs(node) do
		if type(childNode) == "table" and childNode["label"] then
			local nodeString = childNode["label"]
			
			-- attributes available?
			if childNode["xarg"] and type(childNode["xarg"]) == "table" then
				local args = map(function (name, value) return "@" .. name .. "=" .. value end, childNode["xarg"])
				nodeString = nodeString .. "[" .. str.join(",", args) .. "]"				
			end
			
			childNodePath = path .. "/" .. nodeString
			
			list[childNodePath] = childNode
			Xml.pathlist(childNode, childNodePath, list)
		end
	end
end


--! @brief Xml.collect helper
--! @param s string
--! @return table
function Xml.parseargs(s)
  local arg = {}
  string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end

--! @brief parses a xml string (based on http://lua-users.org/wiki/LuaXml)
--! @param s string xml
--! @return table rootnod
function Xml.collect(s)
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
      table.insert(top, {label=label, xarg=Xml.parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=Xml.parseargs(xarg)}
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
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end
