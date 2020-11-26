function GlobalPlayed_AddonLoadedHandler()
	if MyAccount == nil then -- If no account registered
		MyAccount = GlobalPlayed_Account_Create()
	end

	if Characters == nil then -- If no characters registered
		Characters = {  }
	end

	if Options == nil then -- If no options registered
		Options = {
			useAce = GlobalPlayed_Addon_IsLoaded("Ace3")
		}
	end

	local searchResult = GlobalPlayed_FindCharacter(UnitName("player"), GetRealmName())

	if searchResult == nil then
		currentCharacter = GlobalPlayed_Character_Create(UnitName("player"), GetRealmName())
		table.insert(Characters, currentCharacter)
	else
		currentCharacter = searchResult
	end

	GlobalPlayed_LoadUI()
	GlobalPlayed_LoadOptionsPanel()

	GlobalPlayed_Account_UpdatePlayed(MyAccount)
	GlobalPlayedFrame:UnregisterEvent("ADDON_LOADED")
	GlobalPlayed_LoadLdbIntegration()
	GlobalPlayed_Log("Successfully loaded!")
end