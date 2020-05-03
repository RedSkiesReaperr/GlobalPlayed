function AddonLoadedHandler()
	if MyAccount == nil then
		MyAccount = Account:new()
	else
		setmetatable(MyAccount, Account)
	end

	if Characters == nil then -- If no characters registered
		Characters = {  }
	end

	if Options == nil then
		Options = {
			useAce = IsAddOnLoaded("Ace3")
		}
	end

	searchResult = FindCharacter(UnitName("player"), GetRealmName())

	if searchResult == nil then
		currentCharacter = Character:new(UnitName("player"), GetRealmName())
		table.insert(Characters, currentCharacter)
	else
		currentCharacter = searchResult
	end

	MyAccount:UpdatePlayed()
	GlobalPlayedFrame:UnregisterEvent("ADDON_LOADED")
	Log("Successfully loaded!")
end