function TimePlayedMsgHandler(total, currentLvl)
	local totalAsInt = tonumber(total)

	local days = math.floor(totalAsInt / 86400);
	totalAsInt = totalAsInt - (days * 86400);

	local hours = math.floor(totalAsInt / 3600);
	totalAsInt = totalAsInt - (hours * 3600);

	GlobalPlayed_Character_UpdatePlayed(currentCharacter, days, hours)

	Account_UpdatePlayed(MyAccount)
end