----------------------
-- Here is the Character behavior
----------------------
function GlobalPlayed_Character_Create(p_name, p_realm)
	local localizedClass, englishClass = UnitClass("player")

	return {
		name = p_name,
		realm = p_realm,
		class = englishClass,
		days = 0,
		hours = 0,
		totalAsHours = 0
	}
end

function GlobalPlayed_Character_GetPlayed(self)
	local hours = string.format("%02d", self.hours)

	return (self.days .. " days " .. hours .. " hours")
end

function GlobalPlayed_Character_GetPlayedWithTotal(self)
	local hours = string.format("%02d", self.hours)

	return (self.days .. " days " .. hours .. " hours (" .. self.totalAsHours .. "h)")
end

function GlobalPlayed_Character_GetPlayedAsHours(self)
	return self.totalAsHours
end

function GlobalPlayed_Character_GetClassColor(self)
	return GlobalPlayed_ClassColor_GetColor(self.class)
end

function GlobalPlayed_Character_UpdatePlayed(self, p_days, p_hours)
	self.days = p_days
	self.hours = p_hours
	self.totalAsHours = self.hours + (self.days * 24)
end

function GlobalPlayed_GetCharactersOrderedByRealm(list)
	local realms = {}

	for k, v in ipairs(list) do
		if realms[v.realm] == nil then
			realms[v.realm] = {}
		end

		table.insert(realms[v.realm], v)
	end

	return realms
end