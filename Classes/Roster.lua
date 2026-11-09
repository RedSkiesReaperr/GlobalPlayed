----------------------
-- Saved character list: lookup, sorting, grouping and removal
----------------------
-- Case insensitive comparison used for sorting
local function GlobalPlayed_Roster_IsBefore(p_left, p_right)
	return p_left:lower() < p_right:lower()
end

-- Returns the saved character matching name and realm, or nil
function GlobalPlayed_Roster_Find(p_name, p_realm)
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

-- Returns the saved entry of the logged in character, creating it on first login
function GlobalPlayed_Roster_FindOrAddCurrent()
	local name, realm = GlobalPlayed_Character_GetPlayerIdentity()
	local character = GlobalPlayed_Roster_Find(name, realm)

	if character == nil then
		-- Forever characters saved before surnames were handled only have their first name
		character = GlobalPlayed_Roster_Find((UnitName("player")), realm)

		if character ~= nil then
			character.name = name
		end
	end

	if character == nil then
		character = GlobalPlayed_Character_Create(name, realm)
		table.insert(GlobalPlayed_Characters, character)
	else
		GlobalPlayed_Character_RefreshIdentity(character)
	end

	return character
end

-- Returns a copy sorted by name, or by realm then name. The saved list keeps its order
function GlobalPlayed_Roster_Sort(p_characters, p_byRealm)
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
			return GlobalPlayed_Roster_IsBefore(a[first], b[first])
		end

		return GlobalPlayed_Roster_IsBefore(a[second], b[second])
	end)

	return sorted
end

-- Returns the label of the group a character belongs to, following the group option
local function GlobalPlayed_Roster_GetGroupLabel(p_character)
	if GlobalPlayed_Options.groupBy == "class" then
		return GlobalPlayed_Character_GetClassLabel(p_character)
	elseif GlobalPlayed_Options.groupBy == "faction" then
		return GlobalPlayed_Character_GetFactionLabel(p_character)
	end

	return p_character.realm
end

-- Groups characters following the group option, sorted by name, with each group played total
function GlobalPlayed_Roster_Group(p_characters)
	local groups = {}
	local groupsByLabel = {}

	for k, v in ipairs(GlobalPlayed_Roster_Sort(p_characters, false)) do
		local label = GlobalPlayed_Roster_GetGroupLabel(v)
		local group = groupsByLabel[label]

		if group == nil then
			group = { label = label, totalSeconds = 0, totalAsHours = 0, characters = {} }
			groupsByLabel[label] = group
			table.insert(groups, group)
		end

		table.insert(group.characters, v)

		group.totalSeconds = group.totalSeconds + GlobalPlayed_Character_GetTotalSeconds(v)
		group.totalAsHours = GlobalPlayed_PlayedTime_ToHours(group.totalSeconds)
	end

	table.sort(groups, function(a, b) return GlobalPlayed_Roster_IsBefore(a.label, b.label) end)

	return groups
end

-- Removes a character from the saved list and updates the account total.
-- The logged in character cannot be removed, its entry would be recreated at next login
function GlobalPlayed_Roster_Remove(p_character)
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

-- Prints every character played time in chat, sorted by name
function GlobalPlayed_Roster_LogPlayed()
	for k, v in ipairs(GlobalPlayed_Roster_Sort(GlobalPlayed_Characters, false)) do
		GlobalPlayed_Log(GlobalPlayed_Character_GetNameRealmColored(v) .. ": " .. GlobalPlayed_Character_GetPlayedWithTotal(v))
	end
end
