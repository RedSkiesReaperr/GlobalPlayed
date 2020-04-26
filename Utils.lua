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
