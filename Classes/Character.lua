----------------------
-- Here is the Character class
----------------------
Character = {}
Character.__index = Character

function Character:new(p_name, p_realm)
	local newChar = {
		name = p_name,
		realm = p_realm,
		days = 0,
		hours = 0,
		totalAsHours = 0
	}
	setmetatable(newChar, Character)
	return newChar
end

function Character:GetPlayed()
	return (self.days .. " days " .. self.hours .. " hours (" .. self.totalAsHours .. "h)")
end

function Character:UpdatePlayed(p_days, p_hours)
	self.days = p_days
	self.hours = p_hours
	self.totalAsHours = self.hours + (self.days * 24)
end