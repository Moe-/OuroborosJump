---------------------------------
--! @file
--! @brief class/object creation, object oriented programming in lua
---------------------------------

--! @brief creates a new class, optionally derived from a parentclass
--! @param parentclass_or_nil class definition of parent or null
--! @return class definition
function CreateClass(parentclass_or_nil) 
	local p = parentclass_or_nil and setmetatable({},parentclass_or_nil._class_metatable) or {}
	-- OLD: parentclass_or_nil and CopyArray(parentclass_or_nil) or {}
	-- by metatable instead of copying, we avoid problems when not all parentclass methods are registered yet at class creation
	p.New = CreateClassInstance
	p._class_metatable = { __index=p } 
	p._parent_class = parentclass_or_nil
	return p 
end


--! @brief creates a class instance and calls the Init function if it exists with the given parameter ...
--! @param class creates an instance of class and calls the constructor Init(...)
--! @param ... constructor's parameters
--! @return class instance
function CreateClassInstance(class, ...) 
	local o = setmetatable({},class._class_metatable)
	
	if o.Init then o:Init(...) end
	
	return o
end
