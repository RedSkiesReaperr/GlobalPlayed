----------------------
-- Here is the Addon behavior
----------------------
local FOREVER_INTERFACE_MIN = 16000
local FOREVER_INTERFACE_MAX = 20000

-- Returns whether the client is WoW Forever, detected by its interface version
function GlobalPlayed_Addon_IsForever()
	local interfaceVersion = select(4, GetBuildInfo())

	return interfaceVersion >= FOREVER_INTERFACE_MIN and interfaceVersion < FOREVER_INTERFACE_MAX
end

-- Returns whether played time is shown in a window instead of a chat report
function GlobalPlayed_Addon_IsWindowEnabled()
	return GlobalPlayed_Options ~= nil and GlobalPlayed_Options.useWindow == true
end
