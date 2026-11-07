function GlobalPlayed_TimePlayedMsgHandler(total, currentLvl)
	if GlobalPlayed_CurrentCharacter == nil then
		return
	end

	local totalAsInt = tonumber(total)

	local days = math.floor(totalAsInt / 86400);
	totalAsInt = totalAsInt - (days * 86400);

	local hours = math.floor(totalAsInt / 3600);
	totalAsInt = totalAsInt - (hours * 3600);

	GlobalPlayed_Character_UpdatePlayed(GlobalPlayed_CurrentCharacter, days, hours)

	GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
end