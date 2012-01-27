-- will call o:notify(event, ...) on the registered objects

cEventDispatcher = CreateClass()

function cEventDispatcher:Init()
	self.eventTable = {}
end

function cEventDispatcher:sendEvent(event, ...)
	--~ print("EVENT SEND", event, ...)

	if self.eventTable[event] then
		for object,x in pairs(self.eventTable[event]) do
			local objectType = type(object)
			
			if objectType == "table" and object.notify then
				object.notify(object, event, ...)
			elseif objectType == "function" then
				object(event, ...)
			end
		end
	end
end

function cEventDispatcher:registerListener(event, object)
	if object ~= nil then
		if not self.eventTable[event] then
			self.eventTable[event] = {}
		end
		
		self.eventTable[event][object] = true
	end
end

function cEventDispatcher:unregisterListener(event, object)
	if object ~= nil then
		if self.eventTable[event] then
			self.eventTable[event][object] = nil
		end
	end
end

function cEventDispatcher:unregisterObject(object)
	for event,objectTable in pairs(self.eventTable) do
		for object,x in pairs(self.eventTable) do
			self:unregisterListener(event, object)
		end
	end
end

E = cEventDispatcher:New()
