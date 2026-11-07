-- Options added by later versions are filled in for players upgrading with existing settings
local DEFAULT_OPTIONS = {
	useClassColoration = true,
	useShortDuration = false,
	useFactionIcon = true,
	useFullDuration = false
}

function GlobalPlayed_AddonLoadedHandler()
	if GlobalPlayed_MyAccount == nil then -- If no account registered
		GlobalPlayed_MyAccount = GlobalPlayed_Account_Create()
	end

	if GlobalPlayed_Characters == nil then -- If no characters registered
		GlobalPlayed_Characters = {  }
	end

	if GlobalPlayed_Options == nil then -- If no options registered
		GlobalPlayed_Options = {
			useAce = GlobalPlayed_Addon_IsLoaded("Ace3")
		}
	end

	for key, value in pairs(DEFAULT_OPTIONS) do
		if GlobalPlayed_Options[key] == nil then
			GlobalPlayed_Options[key] = value
		end
	end

	GlobalPlayed_Character_MigrateForeverRealms()

	GlobalPlayed_LoadUI()
	GlobalPlayed_LoadOptionsPanel()

	GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
	GlobalPlayed_LoadLdbIntegration()
	GlobalPlayed_Log("Successfully loaded!")
end