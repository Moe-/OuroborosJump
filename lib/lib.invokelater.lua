
PriorityQueue = require "loop.collection.PriorityQueue"

local calls = PriorityQueue()

function InvokeLaterUpdate ()
	local now = love.timer.getTime()

	repeat
		local head = calls:head()
		if head then
			if now >= head.t then
				-- execute and remove the callback
				head.fun()
				calls:dequeue()
			else
				-- no earlier calls
				return
			end
		end
	until not head
end

function InvokeLater (delayInSec, fun)
	local t = love.timer.getTime() + delayInSec
	calls:enqueue({fun=fun, t=t}, t)
end
