local LOGIN_REQUEST_DELAY = 2

function GlobalPlayed_PlayerLoginHandler()
	local name = UnitName("player")
	local realm = GetRealmName()
	local character = GlobalPlayed_FindCharacter(name, realm)

	if character == nil then
		character = GlobalPlayed_Character_Create(name, realm)
		table.insert(GlobalPlayed_Characters, character)
	else
		GlobalPlayed_Character_RefreshIdentity(character)
	end

	GlobalPlayed_CurrentCharacter = character

	C_Timer.After(LOGIN_REQUEST_DELAY, function() GlobalPlayed_RequestPlayed() end)
end
