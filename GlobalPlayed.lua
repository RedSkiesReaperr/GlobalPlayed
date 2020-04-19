----------------------
-- Addon behavior
----------------------
SLASH_GLOBAL_PLAYED1 = '/gp'
SlashCmdList['GLOBAL_PLAYED'] = function()
	LogTotalPlayed()
end

local frame = CreateFrame("Frame")
local currentCharacter = nil

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("TIME_PLAYED_MSG")

frame:SetScript("OnEvent", function(self, event, ...)
	local addon = ...

	if event == "ADDON_LOADED" then
		if addon == "GlobalPlayed" then
			Log("Successfully loaded!")

			if Characters == nil then -- If no characters registered
				Characters = {  }
			end

			searchResult = FindCharacterByName(UnitName("player"))

			if searchResult == nil then
				currentCharacter = Character:new(UnitName("player"))
				table.insert(Characters, currentCharacter)
			else
				currentCharacter = searchResult
			end

			UpdateTotalPlayed()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		-- Do something when player enter in world (also after loading a new place like after tp, etc...)
	end

	if event == "TIME_PLAYED_MSG" then
		local total, currentLvl = ...
		local totalAsInt = tonumber(total)

		local days = math.floor(totalAsInt / 86400);
		totalAsInt = totalAsInt - (days * 86400);

		local hours = math.floor(totalAsInt / 3600);
		totalAsInt = totalAsInt - (hours * 3600);

		currentCharacter.days = days
		currentCharacter.hours = hours

		UpdateTotalPlayed()
	end
end)