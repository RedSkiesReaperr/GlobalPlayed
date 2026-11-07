local LOGIN_REQUEST_DELAY = 2

function GlobalPlayed_PlayerLoginHandler()
	GlobalPlayed_CurrentCharacter = GlobalPlayed_Roster_FindOrAddCurrent()

	C_Timer.After(LOGIN_REQUEST_DELAY, function() GlobalPlayed_RequestPlayed() end)
end
