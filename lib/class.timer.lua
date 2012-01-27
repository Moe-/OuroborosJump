-- class.timer.lua

--! class definition
cTimer = CreateClass()

--! @brief constructor
function cTimer:Init (timeoutInSec)
	self.timeoutInSec = timeoutInSec
	self.secondsSinceLastEvent = 0
end

function cTimer:setTimeout (timeoutInSec)
	self.timeoutInSec = timeoutInSec
end

--! @brief adds time and check if enough time did elapse
--! @return bool
function cTimer:updateAndCheck (dt)
	self.secondsSinceLastEvent = self.secondsSinceLastEvent + dt
	
	if self.secondsSinceLastEvent > self.timeoutInSec then
		self.secondsSinceLastEvent = self.secondsSinceLastEvent - self.timeoutInSec
		return true
	else
		return false
	end
end
