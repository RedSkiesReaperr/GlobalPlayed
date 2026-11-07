----------------------
-- Played time storage and formatting, shared by characters, realms and the account
----------------------
local SECONDS_PER_MINUTE = 60
local SECONDS_PER_HOUR = 3600
local HOURS_PER_DAY = 24

local SHORT_UNITS = { day = "d", hour = "h", minute = "m", second = "s" }
local LONG_UNITS = { day = "days", hour = "hours", minute = "minutes", second = "seconds" }

-- Returns the unit labels matching the short duration option
function GlobalPlayed_PlayedTime_GetUnits()
	if GlobalPlayed_Options.useShortDuration == true then
		return SHORT_UNITS
	end

	return LONG_UNITS
end

-- Converts seconds to whole hours
function GlobalPlayed_PlayedTime_ToHours(p_totalSeconds)
	return math.floor(p_totalSeconds / SECONDS_PER_HOUR)
end

-- Writes seconds plus the days, hours and totalAsHours fields still read by 1.5.x
function GlobalPlayed_PlayedTime_Store(p_target, p_totalSeconds)
	p_target.totalSeconds = p_totalSeconds
	p_target.totalAsHours = GlobalPlayed_PlayedTime_ToHours(p_totalSeconds)
	p_target.days = math.floor(p_target.totalAsHours / HOURS_PER_DAY)
	p_target.hours = p_target.totalAsHours - (p_target.days * HOURS_PER_DAY)
end

-- Formats "Xd YYh", plus minutes and seconds when enabled. p_valueFormat wraps each value, for example in a color
function GlobalPlayed_PlayedTime_Format(p_totalSeconds, p_valueFormat)
	local valueFormat = p_valueFormat or "%s"
	local units = GlobalPlayed_PlayedTime_GetUnits()
	local totalHours = GlobalPlayed_PlayedTime_ToHours(p_totalSeconds)
	local days = math.floor(totalHours / HOURS_PER_DAY)
	local hours = totalHours - (days * HOURS_PER_DAY)
	local text = string.format(valueFormat .. "%s " .. valueFormat .. "%s", days, units.day, string.format("%02d", hours), units.hour)

	if GlobalPlayed_Options.useFullDuration == true then
		local minutes = math.floor(p_totalSeconds / SECONDS_PER_MINUTE) % 60
		local seconds = p_totalSeconds % SECONDS_PER_MINUTE

		text = text .. string.format(" " .. valueFormat .. "%s " .. valueFormat .. "%s", string.format("%02d", minutes), units.minute, string.format("%02d", seconds), units.second)
	end

	return text
end
