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
	return "Account Total: " .. self.days .. " days " .. self.hours .. " hours (" .. self.totalAsHours .. "h)"
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
