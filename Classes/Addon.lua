----------------------
-- Here is the Addon behavior
----------------------
function GlobalPlayed_Addon_IsLoaded(p_name)
	local loaded, _finished  = IsAddOnLoaded(p_name)

	return loaded
end

function GlobalPlayed_Addon_IsAceEnabled()
	if Options ~= nil then
		return (GlobalPlayed_Addon_IsLoaded("Ace3") == true and Options.useAce == true)
	else
		return false
	end
end
