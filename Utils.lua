----------------------
-- Log functions
----------------------
function GlobalPlayed_Log(message)
	print("[GlobalPlayed] " .. message)
end

function LogCharactersPlayed()
	for k, v in ipairs(Characters) do
		iChar = FindCharacter(v.name, v.realm)

		if iChar ~= nil then
			GlobalPlayed_Log(v.name .. "-" .. v.realm .. ": " .. Character_GetPlayed(iChar))
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
			return v
		end
	end
	
	return nil
end
