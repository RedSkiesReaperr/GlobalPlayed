----------------------
-- Log functions
----------------------
function GlobalPlayed_Log(message)
	print("[GlobalPlayed] " .. message)
end

function GlobalPlayed_LogCharactersPlayed()
	for k, v in ipairs(GlobalPlayed_SortCharacters(GlobalPlayed_Characters, false)) do
		GlobalPlayed_Log(GlobalPlayed_Character_GetNameRealmColored(v) .. ": " .. GlobalPlayed_Character_GetPlayedWithTotal(v))
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

local function GlobalPlayed_IsBefore(p_left, p_right)
	return p_left:lower() < p_right:lower()
end

-- Returns a sorted copy, the saved list keeps its order
function GlobalPlayed_SortCharacters(p_characters, p_byRealm)
	local sorted = {}

	for k, v in ipairs(p_characters) do
		table.insert(sorted, v)
	end

	table.sort(sorted, function(a, b)
		local first, second = "name", "realm"

		if p_byRealm == true then
			first, second = "realm", "name"
		end

		if a[first]:lower() ~= b[first]:lower() then
			return GlobalPlayed_IsBefore(a[first], b[first])
		end

		return GlobalPlayed_IsBefore(a[second], b[second])
	end)

	return sorted
end

-- The logged in character cannot be removed, its entry would be recreated at next login
function GlobalPlayed_RemoveCharacter(p_character)
	if GlobalPlayed_Characters == nil or p_character == GlobalPlayed_CurrentCharacter then
		return false
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		if v == p_character then
			table.remove(GlobalPlayed_Characters, k)
			GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)

			return true
		end
	end

	return false
end
