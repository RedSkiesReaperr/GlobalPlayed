-- ----------------------
-- -- Here is the Account behavior
-- ----------------------
function GlobalPlayed_Account_Create()
	return {
		days = 0,
		hours = 0,
		totalAsHours = 0
	}
end

function GlobalPlayed_Account_GetPlayed(self)
	local units = GlobalPlayed_Character_GetPlayTimeUnits()
	local details = GlobalPlayed_Character_GetPlayedDetails(self.totalSeconds or 0, "%s")

	return string.format("Account Total: %s%s %s%s%s (%sh)", self.days, units.day, self.hours, units.hour, details, self.totalAsHours)
end

function GlobalPlayed_Account_UpdatePlayed(self)
	local seconds = 0

	if GlobalPlayed_Characters == nil then
		return
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		seconds = seconds + GlobalPlayed_Character_GetTotalSeconds(v)
	end

	local hours = math.floor(seconds / 3600)
	local daysCount = math.floor(hours / 24)

	self.totalSeconds = seconds
	self.totalAsHours = hours
	self.days = daysCount
	self.hours = hours - (daysCount * 24)
end

function GlobalPlayed_Account_GetCharactersOrderedByRealm(self)
	local realms = {}
	local realm = nil

	for k, v in ipairs(GlobalPlayed_SortCharacters(self, true)) do
		if realm == nil or realm.name ~= v.realm then
			realm = { name = v.realm, totalSeconds = 0 }
			table.insert(realms, realm)
		end

		table.insert(realm, v)

		realm.totalSeconds = realm.totalSeconds + GlobalPlayed_Character_GetTotalSeconds(v)
		realm.totalAsHours = math.floor(realm.totalSeconds / 3600)
	end

	return realms
end