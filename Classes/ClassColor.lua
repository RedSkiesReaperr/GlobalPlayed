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
	DEMONHUNTER = "A330C9",
	EVOKER = "33937F"
}

-- Returns the RRGGBB color of an English class token, or nil when unknown
function GlobalPlayed_ClassColor_GetColor(p_class)
	return classColors[p_class]
end
