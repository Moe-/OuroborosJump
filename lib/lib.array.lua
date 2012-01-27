
-- inversts keys and values
function FlipTable (tbl) local res = {} for k,v in pairs(tbl) do res[v] = k end return res end 

-- takes associative table ({serial1=obj1,serial2=obj2,...}), 
-- returns a list of all values, sorted using cmp callback (table.sort), e.g. {obj1,obj2}
function SortedArrayFromAssocTable (tbl,cmp)
	local mylist = {}
	for k,v in pairs(tbl) do table.insert(mylist,v) end
	table.sort(mylist,cmp)
	return mylist
end


function CreateArray2D () return {} end
function Array2DGet (arr,x,y) return arr[x] and arr[x][y] end
function Array2DSet (arr,x,y,value) local subarr = arr[x] if (not subarr) then subarr = {} arr[x] = subarr end subarr[y] = value end
function Array2DRemove	(arr,x,y) local e = Array2DGet(arr,x,y) Array2DSet(arr,x,y,nil) return e end
function Array2DGetElementCount (arr) local i=0 for x,subarr in pairs(arr) do for y,v in pairs(subarr) do i=i+1 end end return i end
-- calls fun(value,x,y) for all entries
function Array2DForAll (arr,fun) for x,subarr in pairs(arr) do for y,v in pairs(subarr) do fun(v,x,y) end end end


-- numerical keys in, numerical keys out, non associative (keys can change)
function FilterArray (arr,fun) local res = {} for k,v in ipairs(arr) do if (fun(v)) then table.insert(res,v) end end return res end

-- associative (keys are preserved)
function FilterTable (t,fun) local res = {} for k,v in pairs(t) do if (fun(v)) then res[k] = v end end return res end

function GetRandomArrayElement (array) return array and array[1] and array[math.random(#array)] end

function GetRandomTableElementValue (t) return GetRandomArrayElement(table_get_values(t)) end 
function table_get_values (t) local res = {} for k,v in pairs(t) do table.insert(res,v) end return res end

-- returns key,value
function GetRandomTableElement (t)
	local len = countarr(t)
	if (len <= 0) then return end
	local i = 0
	local j = math.random(len)	-- [1,len]
	for k,v in pairs(t) do 
		i = i + 1
		if i == j then return k,v end
	end
end

-- returns true if the needle(value) is in the haystack-array
function in_array (needle,haystack) 
	assert(type(haystack) == "table")
	for k,v in pairs(haystack) do if (v == needle) then return true end end
	return false
end


-- returns a (sorted) list of the keys used in arr
function keys_sorted (arr)
	local res = {}
	for k,v in pairs(arr) do table.insert(res,k) end
	table.sort(res)
	return res
end

-- returns a copy of the array, sorted by key, original keys are lost, new array is indexed one-based
function ksort (arr)
	local res = keys(arr)
	for index,k in pairs(res) do res[index] = arr[k] end
	return res
end

-- push second at the back of first, drops second's keys
-- returns modified first
function ArrayPushArrayBack(first, second)
	local r = {}
	for k,v in pairs(second) do table.insert(first, v) end
	return first
end

-- adds all fields from second to first, but does not overwrite fields that are already set
function ArrayMergeToFirst (first,second) for k,v in pairs(second) do if (first[k] == nil) then first[k] = v end end end

-- returns a new table that is a merge of first and second
-- second overrides any values set by first
function TableMergeToNew (first,second) 
	local res = {}
	for k,v in pairs(first) do res[k] = v end
	for k,v in pairs(second) do res[k] = v end
	return res
end

-- overwrites fields in first by fields in second
function ArrayOverwrite (first,second) for k,v in pairs(second) do first[k] = v end end

-- shallow copy
function CopyArray (arr) local res = {} for k,v in pairs(arr) do res[k] = v end return res end

function countarr(arr) local c = 0 for k,v in pairs(arr) do c = c + 1 end return c end
function isempty(arr) return not (next(arr)) end
function notempty(arr) return (next(arr)) and true end
function arrfirst(arr) local k,v = next(arr) return v end

-- creates an array with n entries equal to value (defaults to one-based indices)
function ArrayRepeat (value,n,startindex) 
	local res = {}
	startindex = startindex or 1
	for i=startindex,(startindex + n - 1) do res[i] = value end
	return res
end


--! @brief array/table map
--! @param func function: fun(key, value) => value
--! @return array of mapped values, does not preserve keys
function map (func, array)
	local new_array = {}
	
	for key, value in pairs(array) do
		table.insert(new_array, func(key, value))
	end
	
	return new_array
end

--! @brief array/table filter
--! @param func function: fun(key, value) => bool
--! @return array of pairs with fun = true
function filter (func, array)
	local new_array = {}

	for key, value in pairs(array) do
		if func(key, value) then
			new_array[key] = value
		end
	end
	
	return new_array
end

function values (array)
	local new_array = {}

	for key, value in pairs(array) do
		table.insert(new_array, value)
	end
	
	return new_array
end

function keys (array)
	local new_array = {}

	for key, value in pairs(array) do
		table.insert(new_array, key)
	end
	
	return new_array
end

function reverse_array (array)
	local count = #array
	
	local flipped = {}
	
	for i = 1,count - 1 do
		flipped[count - i] = array[i]
	end
	
	return flipped
end
