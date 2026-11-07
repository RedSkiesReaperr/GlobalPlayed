local LOGIN_REQUEST_DELAY = 2

function GlobalPlayed_PlayerLoginHandler()
	local name, realm = GlobalPlayed_Character_GetPlayerIdentity()
	local character = GlobalPlayed_FindCharacter(name, realm)

	if character == nil then
		-- Forever characters saved before surnames were handled only have their first name
		character = GlobalPlayed_FindCharacter((UnitName("player")), realm)

		if character ~= nil then
			character.name = name
		end
	end

	if character == nil then
		character = GlobalPlayed_Character_Create(name, realm)
		table.insert(GlobalPlayed_Characters, character)
	else
		GlobalPlayed_Character_RefreshIdentity(character)
	end

	GlobalPlayed_CurrentCharacter = character

	C_Timer.After(LOGIN_REQUEST_DELAY, function() GlobalPlayed_RequestPlayed() end)
end
