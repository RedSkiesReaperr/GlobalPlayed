----------------------
-- Log functions
----------------------
function Log(message)
	print("[GlobalPlayed] " .. message)
end

function LogTotalPlayed()
	Log("Total: " .. TotalDays .. " days " .. TotalHours .. " hours (" .. TotalAsHours .. "h)")
end

----------------------
-- Characters search functions
----------------------
function FindCharacterByName(p_name)
	if Characters == nil then
		return nil
	end

	for k, v in ipairs(Characters) do
		if v.name == p_name then
			return v
		end
	end
	
	return nil
end

----------------------
-- Playtime management functions
----------------------
function UpdateTotalPlayed()
	local days = 0
	local hours = 0

	if Characters == nil then
		return nil
	end

	for k, v in ipairs(Characters) do
		if v.days ~= nil and v.days > 0 then
			days = days + v.days
		end

		if v.hours ~= nil and v.hours > 0 then
			hours = hours + v.hours
		end
	end

	local nbOfDays = math.floor(hours / 24)
	
	TotalDays = days + nbOfDays
	TotalHours = hours - (nbOfDays * 24)
	TotalAsHours = (TotalDays * 24) + TotalHours
end
