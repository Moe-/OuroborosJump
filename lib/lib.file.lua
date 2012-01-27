

function FileAppendContents (filepath,data) -- writes the file contents from one big string
	local fp = io.open(filepath,"ab")
	fp:write(data)
	fp:close()
end

function CopyFile (src,dst) -- not tested with binary/nontext files, should work, but not sure yet
	local data = love.filesystem.read(src)
	if (data) then love.filesystem.write(dst,data) end
end

function normalisePath (path)
	path = string.gsub(path, "//", "/")
	path = string.gsub(path, "/%./", "/")
	
	path = string.gsub(path, "([^.]+)/%.%./", "")
		
	return path
end


-- basename("\\some\path\filename.tga") = "filename.tga"
function basename (path)
	local arr = str.split("[\\/]",path)
	local arrlen = arr and table.getn(arr) or 0
	if (arrlen > 0) then return arr[arrlen] end
end

--! @brief returns directory of give file
--! @param file string complete path eg. /lala/file.txt
--! @return string eg. /lala/
function basepath (file)
	local basename = basename(file)
	return string.gsub(file, str.patternQuote(basename) .. "$", "")
end

function fileextension (path)
	local arr = str.split("[\\.]",path)
	local arrlen = arr and table.getn(arr) or 0
	if (arrlen > 0) then return arr[arrlen] end
end

	
-- returns true if the file exists else false	
function file_exists(filename)
	local f = io.open(filename,"r")
	if f then
		io.close(f)
		return true
	else
		return false
	end
end

