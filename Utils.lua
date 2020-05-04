----------------------
-- Log functions
----------------------
function Log(message)
	print("[GlobalPlayed] " .. message)
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
-- Dependencies functions
----------------------
function IsAceLoaded()
	return IsAddOnLoaded("Ace3")
end

function IsAceEnabled()
	if Options ~= nil then
		return (IsAceLoaded() == true and Options.useAce == true)
	else
		return false
	end
end