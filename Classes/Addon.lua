----------------------
-- Here is the Addon behavior
----------------------
function GlobalPlayed_Addon_IsLoaded(p_name)
	local loaded = C_AddOns.IsAddOnLoaded(p_name)

	return loaded
end

function GlobalPlayed_Addon_IsForever()
	local interfaceVersion = select(4, GetBuildInfo())

	return interfaceVersion >= 16000 and interfaceVersion < 20000
end

function GlobalPlayed_Addon_IsAceEnabled()
	if GlobalPlayed_Options ~= nil then
		return (GlobalPlayed_Addon_IsLoaded("Ace3") == true and GlobalPlayed_Options.useAce == true)
	else
		return false
	end
end
