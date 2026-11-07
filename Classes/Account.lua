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