----------------------
-- Log functions
----------------------
function Log(message)
	print("[GlobalPlayed] " .. message)
end

function LogAccountPlayed()
	Log("Total: " .. TotalDays .. " days " .. TotalHours .. " hours (" .. TotalAsHours .. "h)")
end

function LogCharactersPlayed()
	for k, v in ipairs(Characters) do
		iChar = FindCharacter(v.name, v.realm)

		if iChar ~= nil then
			Log(v.name .. "-" .. v.realm .. ": " .. iChar:GetPlayed())
		end
	end
end

----------------------
-- Characters search functions
----------------------
function FindCharacter(p_name, p_realm)
	if Characters == nil then
		return nil
	end

	for k, v in ipairs(Characters) do
		if v.name == p_name and v.realm == p_realm then
			setmetatable(v, Character)
			return v
		end
	end
	
	return nil
end

----------------------
-- Playtime management functions
----------------------
function UpdateAccountPlayed()
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

	TotalAsHours = hours
	TotalDays = daysCount
	TotalHours = hours - (daysCount * 24)
end