----------------------
-- Here is the Account class
----------------------
Account = {}
Account.__index = Account

function Account:new()
	local newAcc = {
		days = 0,
		hours = 0,
		totalAsHours = 0
	}
	setmetatable(newAcc, Account)
	return newAcc
end

function Account:GetPlayed()
	return "Account Total: " .. self.days .. " days " .. self.hours .. " hours (" .. self.totalAsHours .. "h)"
end

function Account:UpdatePlayed()
	local hours = 0

	if Characters == nil then
		return nil
	end

	for k, v in ipairs(Characters) do
		if v.totalAsHours ~= nil and v.totalAsHours > 0 then
			hours = hours + v.totalAsHours
		end
	end

	local daysCount = math.floor(hours / 24)

	self.totalAsHours = hours
	self.days = daysCount
	self.hours = hours - (daysCount * 24)
end