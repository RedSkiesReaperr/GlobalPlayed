----------------------
-- Here is the Addon behavior
----------------------
function Addon_IsLoaded(p_name)
	local loaded, _finished  = IsAddOnLoaded(p_name)

	return loaded
end

function Addon_IsAceEnabled()
	if Options ~= nil then
		return (Addon_IsLoaded("Ace3") == true and Options.useAce == true)
	else
		return false
	end
end
