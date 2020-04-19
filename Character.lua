----------------------
-- Here is the Character class
----------------------
Character = {}
Character.__index = Character

function Character:new(p_name)
	local newChar = {
		name = p_name,
		days = 0,
		hours = 0
	}
	setmetatable(newChar, Character)
	return newChar
end