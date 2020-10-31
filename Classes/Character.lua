----------------------
-- Here is the Character behavior
----------------------
function Character_Create(p_name, p_realm)
	return {
		name = p_name,
		realm = p_realm,
		days = 0,
		hours = 0,
		totalAsHours = 0
	}
end

function Character_GetPlayed(self)
	return (self.days .. " days " .. self.hours .. " hours (" .. self.totalAsHours .. "h)")
end

function Character_UpdatePlayed(self, p_days, p_hours)
	self.days = p_days
	self.hours = p_hours
	self.totalAsHours = self.hours + (self.days * 24)
end