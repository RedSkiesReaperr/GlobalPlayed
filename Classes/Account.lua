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
	local daysUnit, hoursUnit = nil

	if GlobalPlayed_Options.useShortDuration == true then
		daysUnit = "d"
		hoursUnit = "h"
	else
		daysUnit = "days"
		hoursUnit = "hours"
	end

	return string.format("Account Total: %s%s %s%s (%sh)", self.days, daysUnit, self.hours, hoursUnit, self.totalAsHours)
end

function GlobalPlayed_Account_UpdatePlayed(self)
	local hours = 0

	if GlobalPlayed_Characters == nil then
		return nil
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		if v.totalAsHours ~= nil and v.totalAsHours > 0 then
			hours = hours + v.totalAsHours
		end
	end

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

		if realms[v.realm]['totalAsHours'] == nil then realms[v.realm]['totalAsHours'] = 0 end

		realms[v.realm]['totalAsHours'] = realms[v.realm]['totalAsHours'] + v.totalAsHours
	end

	return realms
end