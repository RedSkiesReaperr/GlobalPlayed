-- ----------------------
-- -- Here is the Account behavior
-- ----------------------
function GlobalPlayed_Account_Create()
	return {
		days = 0,
		hours = 0,
		totalAsHours = 0,
		totalSeconds = 0
	}
end

function GlobalPlayed_Account_GetPlayed(self)
	return "Account Total: " .. GlobalPlayed_PlayedTime_Format(self.totalSeconds or 0) .. string.format(" (%sh)", self.totalAsHours)
end

function GlobalPlayed_Account_UpdatePlayed(self)
	local seconds = 0

	if GlobalPlayed_Characters == nil then
		return
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		seconds = seconds + GlobalPlayed_Character_GetTotalSeconds(v)
	end

	GlobalPlayed_PlayedTime_Store(self, seconds)
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
		realm.totalAsHours = GlobalPlayed_PlayedTime_ToHours(realm.totalSeconds)
	end

	return realms
end