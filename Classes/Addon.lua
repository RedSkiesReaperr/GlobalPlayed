----------------------
-- Here is the Addon behavior
----------------------
function GlobalPlayed_Addon_IsLoaded(p_name)
	local loaded, _finished  = C_AddOns.IsAddOnLoaded(p_name)

	return loaded
end

function GlobalPlayed_Addon_IsAceEnabled()
	if GlobalPlayed_Options ~= nil then
		return (GlobalPlayed_Addon_IsLoaded("Ace3") == true and GlobalPlayed_Options.useAce == true)
	else
		return false
	end
end
