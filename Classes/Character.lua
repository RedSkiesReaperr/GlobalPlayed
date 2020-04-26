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
		hours = 0
	}
	setmetatable(newChar, Character)
	return newChar
end

function Character:GetPlayed()
	return (self.days .. " days " .. self.hours .. " hours") --TODO: Add total as hours
end