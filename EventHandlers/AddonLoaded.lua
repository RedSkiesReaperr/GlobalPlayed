----------------------
-- Saved variables setup when the addon loads
----------------------
local L = GlobalPlayed_L

-- Options added by later versions are filled in for players upgrading with existing settings
local DEFAULT_OPTIONS = {
	useClassColoration = true,
	useShortDuration = false,
	useFactionIcon = true,
	useFullDuration = false,
	useWindow = true,
	brokerText = "name",
	groupBy = "realm",
	sortBy = "name"
}

-- Settings of the removed Ace3 window
local OBSOLETE_OPTIONS = { "useAce", "useNativeWindow", "uiFrameStatus" }

-- Initializes saved variables and migrations, then loads the options panel and broker
function GlobalPlayed_AddonLoadedHandler()
	if GlobalPlayed_MyAccount == nil then
		GlobalPlayed_MyAccount = GlobalPlayed_Account_Create()
	end

	if GlobalPlayed_Characters == nil then
		GlobalPlayed_Characters = {}
	end

	if GlobalPlayed_Options == nil then
		GlobalPlayed_Options = {}
	end

	for _, key in ipairs(OBSOLETE_OPTIONS) do
		GlobalPlayed_Options[key] = nil
	end

	for key, value in pairs(DEFAULT_OPTIONS) do
		if GlobalPlayed_Options[key] == nil then
			GlobalPlayed_Options[key] = value
		end
	end

	if GlobalPlayed_Options.minimap == nil then
		GlobalPlayed_Options.minimap = { hide = false, showInCompartment = true }
	end

	GlobalPlayed_Character_MigrateForeverRealms()

	GlobalPlayed_LoadOptionsPanel()

	GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
	GlobalPlayed_LoadLdbIntegration()
	GlobalPlayed_Log(L["Successfully loaded!"])
end
