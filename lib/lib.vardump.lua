
-- returns a string representation of data
function SmartDump (data,dumptablelevels) 
	dumptablelevels = dumptablelevels or 1
	if (type(data) == "table") then
		if (dumptablelevels <= 0) then return tostring(data) end
		local res = "{"
		for k,v in pairs(data) do 
			local keystring = (type(k) == "number") and ("["..k.."]") or tostring(k)
			res = res..keystring.."="..SmartDump(v,dumptablelevels-1).."," 
		end
		return res.."}"
	elseif (type(data) == "number") then
		if		(math.floor(data) ~= data) then	return sprintf("%f",data)
		elseif	(data <= 8		) then	return sprintf("%d",data)
		elseif	(data <= 0xff	) then	return sprintf("%d=0x%02x",data,data)
		elseif	(data <= 0xffff	) then	return sprintf("%d=0x%04x",data,data)
		else							return sprintf("0x%08x",data)
		end
	elseif (type(data) == "string") then
		return "\""..data.."\""
	else 
		return tostring(data)
	end
end

-- returns a string representation of the variable, mostly used for arrays : {field1=value1,field2=value2,...}
function vardump (x,aux)
	aux = aux or vardump_aux
	local mytype = type(x)
	if (mytype == "table") then
		local res = ""
		local keys = {}
		for k,v in pairs(x) do table.insert(keys,k) end
		table.sort(keys)
		for ign,k in pairs(keys) do res = res..aux(k).."="..aux(x[k]).."," end
		return res
	else 
		return aux(x)
	end 
end
function arrdump (arr) return str.join(",",arr) end

-- returns a string representation of the variable (recursive), mostly used for arrays : {field1=value1,field2=value2,...}
function vardump_rec (x,aux,maxdepth)
	aux = aux or vardump_aux
	maxdepth = maxdepth or 3
	local mytype = type(x)
	if (mytype == "table") then
		local res = "table["
		if maxdepth > 0 then
			for k,v in pairs(x) do res = res..aux(k).."="..vardump_rec(v,aux,maxdepth-1).."," end
		else
			for k,v in pairs(x) do res = res..aux(k).."="..aux(v).."," end
		end
		res = res .. "]"
		return res
	else 
		return aux(x)
	end 
end

-- vardump2 : no hexadecimal display of numbers
function vardump2 (x) return vardump(x,function (a) return tostring(a) end) end

-- non recursive ! would result in infinite recursion for double linked things (dialog.uoContainer.dialog.uoContainer...)
function vardump_aux (x) 
	local mytype = type(x)
	if (mytype == "number") then
		return sprintf("0x%08x",x)
	elseif (mytype == "string") then
		return sprintf("%s",x)
	elseif (mytype == "boolean") then
		if x then return "true" else return "false" end
	else
		return tostring(x)
	end
end
