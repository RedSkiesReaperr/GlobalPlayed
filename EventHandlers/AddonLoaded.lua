function AddonLoadedHandler()
	if MyAccount == nil then -- If no account registered
		MyAccount = Account:new()
	else
		setmetatable(MyAccount, Account)
	end

	if Characters == nil then -- If no characters registered
		Characters = {  }
	end

	if Options == nil then -- If no options registered
		Options = {
			useAce = IsAceLoaded()
		}
	end

	searchResult = FindCharacter(UnitName("player"), GetRealmName())

	if searchResult == nil then
		currentCharacter = Character:new(UnitName("player"), GetRealmName())
		table.insert(Characters, currentCharacter)
	else
		currentCharacter = searchResult
	end

	LoadUI()
	LoadOptionsPanel()

	MyAccount:UpdatePlayed()
	GlobalPlayedFrame:UnregisterEvent("ADDON_LOADED")
	Log("Successfully loaded!")
end