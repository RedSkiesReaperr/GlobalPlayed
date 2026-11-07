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

	return string.format("Account Total: %s%s %s%s (%sh)", self.days, units.day, self.hours, units.hour, self.totalAsHours)
end

function GlobalPlayed_Account_UpdatePlayed(self)
	local seconds = 0

	if GlobalPlayed_Characters == nil then
		return nil
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		seconds = seconds + GlobalPlayed_Character_GetTotalSeconds(v)
	end

	local hours = math.floor(seconds / 3600)
	local daysCount = math.floor(hours / 24)

	self.totalAsHours = hours
	self.days = daysCount
	self.hours = hours - (daysCount * 24)
end

function GlobalPlayed_Account_GetCharactersOrderedByRealm(self)
	local realms = {}

	for k, v in ipairs(self) do
		if realms[v.realm] == nil then
			realms[v.realm] = {}
		end

		table.insert(realms[v.realm], v)

		realms[v.realm]['totalSeconds'] = (realms[v.realm]['totalSeconds'] or 0) + GlobalPlayed_Character_GetTotalSeconds(v)
		realms[v.realm]['totalAsHours'] = math.floor(realms[v.realm]['totalSeconds'] / 3600)
	end

	return realms
end