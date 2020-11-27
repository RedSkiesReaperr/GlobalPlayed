local classColors = {
	WARRIOR = "C79C6E",
	PALADIN = "F58CBA",
	HUNTER = "ABD473",
	ROGUE = "FFF569",
	PRIEST = "FFFFFF",
	DEATHKNIGHT = "C41F3B",
	SHAMAN = "0070DE",
	MAGE = "69CCF0",
	WARLOCK = "9482C9",
	MONK = "00FF96",
	DRUID = "FF7D0A",
	DEMONHUNTER = "A330C9"
}

function GlobalPlayed_ClassColor_GetColor(class)
	return classColors[class]
end