----------------------
-- Optional import of played time from DataStore, the database used by Altoholic
----------------------
local DATASTORE_ACCOUNT = "Default"

-- Returns whether DataStore and its characters module are loaded
function GlobalPlayed_DataStoreImport_IsAvailable()
	return DataStore ~= nil and DataStore.GetPlayTime ~= nil
end

-- Adds or updates one character from its DataStore key. Returns "added", "updated" or nil
local function GlobalPlayed_DataStoreImport_ImportCharacter(p_name, p_realm, p_key)
	-- GetPlayTime returns 0 when the player hides their played time in DataStore
	local seconds = DataStore:GetPlayTime(p_key)

	if seconds == nil or seconds <= 0 then
		return nil
	end

	local realm = GlobalPlayed_Character_NormalizeRealm(p_realm)
	local character = GlobalPlayed_Roster_Find(p_name, realm)

	if character == nil then
		local _, class = DataStore:GetCharacterClass(p_key)
		local faction = DataStore:GetCharacterFaction(p_key)

		character = GlobalPlayed_Character_CreateImported(p_name, realm, class, faction)
		GlobalPlayed_Character_UpdatePlayed(character, seconds)
		table.insert(GlobalPlayed_Characters, character)

		return "added"
	end

	if seconds > GlobalPlayed_Character_GetTotalSeconds(character) then
		GlobalPlayed_Character_UpdatePlayed(character, seconds)

		return "updated"
	end

	return nil
end

-- Imports every character of this account, keeping the highest known played time, and reports the result in chat
function GlobalPlayed_DataStoreImport_Run()
	local added, updated = 0, 0

	for realm in pairs(DataStore:GetRealms(DATASTORE_ACCOUNT)) do
		for name, key in pairs(DataStore:GetCharacters(realm, DATASTORE_ACCOUNT)) do
			local result = GlobalPlayed_DataStoreImport_ImportCharacter(name, realm, key)

			if result == "added" then
				added = added + 1
			elseif result == "updated" then
				updated = updated + 1
			end
		end
	end

	GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
	GlobalPlayed_Log(string.format("DataStore import: %d added, %d updated", added, updated))
end
