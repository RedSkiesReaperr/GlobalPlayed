----------------------
-- Here is the Addon behavior
----------------------
local FOREVER_INTERFACE_MIN = 16000
local FOREVER_INTERFACE_MAX = 20000

-- Returns whether an addon is loaded
function GlobalPlayed_Addon_IsLoaded(p_name)
	local loaded = C_AddOns.IsAddOnLoaded(p_name)

	return loaded
end

-- Returns whether the client is WoW Forever, detected by its interface version
function GlobalPlayed_Addon_IsForever()
	local interfaceVersion = select(4, GetBuildInfo())

	return interfaceVersion >= FOREVER_INTERFACE_MIN and interfaceVersion < FOREVER_INTERFACE_MAX
end

-- Returns whether the Ace3 window should be used: Ace3 loaded and option enabled
function GlobalPlayed_Addon_IsAceEnabled()
	return GlobalPlayed_Options ~= nil and GlobalPlayed_Addon_IsLoaded("Ace3") == true and GlobalPlayed_Options.useAce == true
end

-- Returns whether played time is shown in a window instead of a chat report
function GlobalPlayed_Addon_IsWindowEnabled()
	return (GlobalPlayed_Options ~= nil and GlobalPlayed_Options.useNativeWindow == true) or GlobalPlayed_Addon_IsAceEnabled()
end
