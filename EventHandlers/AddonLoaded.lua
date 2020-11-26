function AddonLoadedHandler()
	if MyAccount == nil then -- If no account registered
		MyAccount = Account_Create()
	end

	if Characters == nil then -- If no characters registered
		Characters = {  }
	end

	if Options == nil then -- If no options registered
		Options = {
			useAce = Addon_IsLoaded("Ace3")
		}
	end

	searchResult = GlobalPlayed_FindCharacter(UnitName("player"), GetRealmName())

	if searchResult == nil then
		currentCharacter = Character_Create(UnitName("player"), GetRealmName())
		table.insert(Characters, currentCharacter)
	else
		currentCharacter = searchResult
	end

	LoadUI()
	LoadOptionsPanel()

	Account_UpdatePlayed(MyAccount)
	GlobalPlayedFrame:UnregisterEvent("ADDON_LOADED")
	LoadLdbIntegration()
	GlobalPlayed_Log("Successfully loaded!")
end