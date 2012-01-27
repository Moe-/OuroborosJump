math.randomseed(os.time())

--function printf(...) io.write(string.format("%d:",Client_GetTicks())..string.format(...)) end
-- protected call string fromatting, errors don't crash the program
function pformat(...) 
	local success,s = pcall(string.format,...)
	if (success) then return s end
	s = "string.format error ("..s..") #"..str.join(",",{...}).."#"
	print(s)
	print(_TRACEBACK())
	return s
end

function printf(...) io.write(pformat(...)) end
function sprintf(...) return pformat(...) end


function prints (...) -- summarizes variable argument like print(..) to a single string using tabs
	local res = {}
	for i=1,arg.n do 
		local v = arg[i]
		local t = type(v)
		if (t == "nil") then v = "nil"
		elseif (t == "string") then 
		elseif (t == "number") then 
		elseif (t == "boolean") then v = tostring(v)
		else v = t..":"..tostring(v) -- tostring needed for nil entries to work
		end
		table.insert(res,v) 
	end
	return table.concat(res,"\t")
end




function GetOneLineBackTrace (l,d)
	local res = {}
	l = (l or 1) + 1
	local x = 0
	repeat 
		local i = debug.getinfo(l,"Sl")
		if (not i ) then break end
		table.insert(res,i.source..":"..i.currentline)
		l = l + 1
		x = x + 1
	until x > (d or 3)
	return table.concat(res," ")
end


-- appends zero terminator to byte array
function StringToByteArrayZeroTerm (str)
	local res = {}
	local len = string.len(str)
	for i = 1,len do
		table.insert(res,string.byte(str,i))
	end
	table.insert(res,0)
	return res
end

-- overwrites a part of "bytes" starting at "startpos" with "bytes_insert"
-- startpos is one-based
function OverwriteByteArrayPart (bytes,startpos,bytes_insert)
	for k,v in ipairs(bytes_insert) do bytes[k+startpos-1] = v end
end

function IsNumber (txt) return (tonumber(txt) or "").."" == txt end

function clone		(t) local res = {} for k,v in pairs(t) do res[k] = v end return res end
function clonemod	(t,mods) local res = {} for k,v in pairs(t) do res[k] = v end for k,v in pairs(mods) do res[k] = v end return res end
function tablemod	(t,mods) for k,v in pairs(mods) do t[k] = v end return t end

-- executes command and returns output as array or lines with newline char removed (not tested on win)
function ExecGetLines (cmd)
	local file = io.popen(cmd)
	local res = {}
	for line in file:lines() do table.insert(res,string.sub(line,1,-1)) end -- remove newline
	file:close()
	return res
end

gDebugCategories = {} -- gDebugCategories.mycat = false to disable output
function printdebug(category,...)
	if (gDebugCategories[category] == nil or gDebugCategories[category]) then 
		if type(gDebugCategories[category]) == "string" then
			local s = ""
			for k,v in pairs(arg) do s = s.."\t"..v end
			local file = io.open(gDebugCategories[category],"a")
			file:write("DEBUG["..category.."] "..s.."\n")
			file:close()
		else
			print("DEBUG["..category.."]",...) 
		end
	end
end


-- returns r,g,b  in [0,1] each from html like hex-colors "b16a00" or "0xb16a00" or "#b16a00"
function hex2rgb (hex)
	if (string.sub(hex,1,2) == "0x") then return hex2rgb(string.sub(hex,3)) end
	if (string.sub(hex,1,1) == "#") then return hex2rgb(string.sub(hex,2)) end
	return 	tonumber(string.sub(hex,1,2),16)/255,
			tonumber(string.sub(hex,3,4),16)/255,
			tonumber(string.sub(hex,5,6),16)/255
end

function hex2num (s) -- interprets strings starting with "0x" (like "0x123") as hex, and as decimal number otherwise
	return ((string.sub(s,1,2) == "0x") and tonumber(string.sub(s,3),16)) or tonumber(s)
end

function hex (v,digits) return sprintf(digits and ("0x%0"..digits.."x") or "0x%x",v) end

	
-- interprets a binary string (e.g. from file:read(number)) as integer
function bin2num (bin) 
	if (not bin) then return nil end -- this usually means that eof was reached before the data could be read
	local len = string.len(bin)
	local res = 0
	for i = 1,len do
		res = res + string.byte(bin,i) * (256 ^ (i-1))
	end
	return res
	-- TODO : endian ? (256 ^ (i-1)) might have to be adjusted, but seems to work for now
end

--- changes size to 2^n where n>=4
function texsize (i) 
	local res = 16
	while (res < i) do res = res * 2 end
	return res
end


function ParseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				if (not startp) then	
					startp,endp = pos,#line
					--~ print("warning, unfinished quote in line:",line)
				end
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example :   value1,"blub""blip""boing",value3  will result  in blub"blip"boing    for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end
--~ test : print(unpack(ParseCSVLine([[123,"asd,asd",132,"blub""blip""boing",peng]])))

-- returns h,s,v [h, s, v in 0-1]
function ColorRGB2HSV (r,g,b)
	local rgbmin = math.min(r,g,b)
	local rgbmax = math.max(r,g,b)
	
	local h,s,v = 0,0,0
	
	local d = rgbmax - rgbmin
	
	if r == rgbmax and g >= b then 	h = 60 * (g-b)/d+0
	elseif r == rgbmax and g < b then 	h = 60 * (g-b)/d+360
	elseif g == rgbmax then 			h = 60 * (b-r)/d+120
	elseif b == rgbmax then 			h = 60 * (r-g)/d+240
	end
	
	h = h / 360
	
	if rgbmax == 0 then s = 0
	else s = 1 - rgbmin/rgbmax end
	
	v = rgbmax
	
	return h,s,v
end

-- returns r, g, b [r, g, b in 0-1]
function ColorHSV2RGB (h,s,v)
	h = h * 360
	local hi = math.fmod(math.floor(h/60),6)
	local f = h/60 - hi
	local p = v * (1-s)
	local q = v * (1-f*s)
	local t = v * (1-(1-f)*s)
	
	if hi == 0 then return v,t,p
	elseif hi == 1 then return q,v,p
	elseif hi == 2 then return p,v,t
	elseif hi == 3 then return p,q,v
	elseif hi == 4 then return t,p,v
	elseif hi == 5 then return v,p,q
	end
end


function DumpGlobalMemTreesizeSize(x,level)
	level = level or 0
	local limit = 0
	
	if level > 8 then return 0 end
	
	if type(x) == "table" then
		local sum = 4
		for k,v in pairs(x) do
			local size = DumpGlobalMemTreesizeSize(v,level+1)
			sum = sum + size
		end
		if level < limit then 
			for i=0,level do printf("  ") end
			print("SUM",sum)
		end
		return sum
	elseif type(x) == "string" then
		return string.len(x)
	else return 4 end
end

function DumpGlobalMemTreesize(filename)
	local s = {}
	local l = {}
	
	local m = 0
	local n = ""
	local sum = 0
	for k,v in pairs(_G) do
		if type(v) ~= "function" and k ~= "_G" then
			local size = DumpGlobalMemTreesizeSize(v)
			if size > m then
				m = size
				n = k
			end
			
			table.insert(l,k)
			s[k] = size
			
			sum = sum + size
		end
	end
	
	table.sort(l,function(a,b)
		return s[a] < s[b]
	end)
	
	for k,v in pairs(l) do
		printf("%-50s\t%10d\n",v,s[v])
	end
end
