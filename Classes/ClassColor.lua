----------------------
-- Class colors: the official values of the game RAID_CLASS_COLORS table
----------------------
local classColors = {
	WARRIOR = "C69B6D",
	PALADIN = "F48CBA",
	HUNTER = "AAD372",
	ROGUE = "FFF468",
	PRIEST = "FFFFFF",
	DEATHKNIGHT = "C41E3A",
	SHAMAN = "0070DD",
	MAGE = "3FC7EB",
	WARLOCK = "8788EE",
	MONK = "00FF98",
	DRUID = "FF7C0A",
	DEMONHUNTER = "A330C9",
	EVOKER = "33937F"
}

-- Returns the RRGGBB color of an English class token, or nil when unknown
function GlobalPlayed_ClassColor_GetColor(p_class)
	return classColors[p_class]
end
