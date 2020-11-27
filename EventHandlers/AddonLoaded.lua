function GlobalPlayed_AddonLoadedHandler()
	if GlobalPlayed_MyAccount == nil then -- If no account registered
		GlobalPlayed_MyAccount = GlobalPlayed_Account_Create()
	end

	if GlobalPlayed_Characters == nil then -- If no characters registered
		GlobalPlayed_Characters = {  }
	end

	if GlobalPlayed_Options == nil then -- If no options registered
		GlobalPlayed_Options = {
			useAce = GlobalPlayed_Addon_IsLoaded("Ace3"),
			useClassColoration = true,
			useShortDuration = false
		}
	end

	local searchResult = GlobalPlayed_FindCharacter(UnitName("player"), GetRealmName())

	if searchResult == nil then
		currentCharacter = GlobalPlayed_Character_Create(UnitName("player"), GetRealmName())
		table.insert(GlobalPlayed_Characters, currentCharacter)
	else
		currentCharacter = searchResult
	end

	GlobalPlayed_LoadUI()
	GlobalPlayed_LoadOptionsPanel()

	GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
	GlobalPlayedFrame:UnregisterEvent("ADDON_LOADED")
	GlobalPlayed_LoadLdbIntegration()
	GlobalPlayed_Log("Successfully loaded!")
end