function AddonLoadedHandler()
	if Characters == nil then -- If no characters registered
		Characters = {  }
	end

	searchResult = FindCharacter(UnitName("player"), GetRealmName())

	if searchResult == nil then
		currentCharacter = Character:new(UnitName("player"), GetRealmName())
		table.insert(Characters, currentCharacter)
	else
		currentCharacter = searchResult
	end

	UpdateTotalPlayed()
	GlobalPlayedFrame:UnregisterEvent("ADDON_LOADED")
	Log("Successfully loaded!")
end