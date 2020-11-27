----------------------
-- Log functions
----------------------
function GlobalPlayed_Log(message)
	print("[GlobalPlayed] " .. message)
end

function GlobalPlayed_LogCharactersPlayed()
	local classColor = nil

	for k, v in ipairs(GlobalPlayed_Characters) do
		iChar = GlobalPlayed_FindCharacter(v.name, v.realm)

		if GlobalPlayed_Options.useClassColoration == true then
			classColor = "|cff" .. GlobalPlayed_Character_GetClassColor(iChar)
		else
			classColor = "|r"
		end

		if iChar ~= nil then
			GlobalPlayed_Log(classColor .. v.name .. "-" .. v.realm .. "|r: " .. GlobalPlayed_Character_GetPlayed(iChar) .. " (" .. iChar.totalAsHours .. "h)")
		end
	end
end

----------------------
-- GlobalPlayed_Characters search functions
----------------------
function GlobalPlayed_FindCharacter(p_name, p_realm)
	if GlobalPlayed_Characters == nil then
		return nil
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		if v.name == p_name and v.realm == p_realm then
			return v
		end
	end
	
	return nil
end
