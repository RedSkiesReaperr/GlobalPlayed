----------------------
-- Character setup at login
----------------------
local LOGIN_REQUEST_DELAY = 2

-- Finds or creates the logged in character, then silently requests its played time
function GlobalPlayed_PlayerLoginHandler()
	GlobalPlayed_CurrentCharacter = GlobalPlayed_Roster_FindOrAddCurrent()

	C_Timer.After(LOGIN_REQUEST_DELAY, function() GlobalPlayed_RequestPlayed() end)
end
