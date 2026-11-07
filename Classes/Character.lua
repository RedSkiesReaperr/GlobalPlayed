----------------------
-- Here is the Character behavior
----------------------
local FOREVER_REALM = "WoW Forever"
local FACTION_ICONS_PATH = "Interface\\AddOns\\GlobalPlayed\\Icons\\Factions\\"
local FACTION_ICONS = { Alliance = "alliance", Horde = "horde" }
local NEUTRAL_ICON = "neutral"

-- Returns the name and realm used to store the logged in character.
-- Forever has no player facing realms and UnitName returns the surname as second value
function GlobalPlayed_Character_GetPlayerIdentity()
	local name, surname = UnitName("player")

	if GlobalPlayed_Addon_IsForever() == false then
		return name, GetRealmName()
	end

	if surname ~= nil and surname ~= "" then
		name = name .. " " .. surname
	end

	return name, FOREVER_REALM
end

-- Moves every saved character to the Forever group on a Forever client.
-- Saved variables are per client, so every entry there is a Forever character
function GlobalPlayed_Character_MigrateForeverRealms()
	if GlobalPlayed_Addon_IsForever() == false then
		return
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		v.realm = FOREVER_REALM
	end
end

-- Creates a character entry with an empty played time
function GlobalPlayed_Character_Create(p_name, p_realm)
	local character = {
		name = p_name,
		realm = p_realm,
		days = 0,
		hours = 0,
		totalAsHours = 0,
		totalSeconds = 0
	}

	GlobalPlayed_Character_RefreshIdentity(character)

	return character
end

-- Updates class and faction from the logged in player, so only valid for the current character
function GlobalPlayed_Character_RefreshIdentity(self)
	local _, englishClass = UnitClass("player")
	local englishFaction = UnitFactionGroup("player")

	self.class = englishClass or self.class
	self.faction = englishFaction or self.faction
end

-- Formats the played time with white values, for tooltips
function GlobalPlayed_Character_GetPlayed(self)
	return GlobalPlayed_PlayedTime_Format(GlobalPlayed_Character_GetTotalSeconds(self), "|cffffffff%s|r")
end

-- Formats the played time followed by the total in hours
function GlobalPlayed_Character_GetPlayedWithTotal(self)
	return GlobalPlayed_PlayedTime_Format(GlobalPlayed_Character_GetTotalSeconds(self)) .. string.format(" (%sh)", self.totalAsHours)
end

-- Returns the whole played time in hours
function GlobalPlayed_Character_GetPlayedAsHours(self)
	return self.totalAsHours
end

-- Returns the character class color, or nil when unknown
function GlobalPlayed_Character_GetClassColor(self)
	return GlobalPlayed_ClassColor_GetColor(self.class)
end

-- Wraps text in the character class color when enabled.
-- Unknown or missing classes keep the default text color instead of breaking the display
local function GlobalPlayed_Character_Colorize(self, p_text)
	local color = GlobalPlayed_Character_GetClassColor(self)

	if GlobalPlayed_Options.useClassColoration ~= true or color == nil then
		return p_text
	end

	return "|cff" .. color .. p_text .. "|r"
end

-- Returns the name, class colored when the option is enabled
function GlobalPlayed_Character_GetNameColored(self)
	return GlobalPlayed_Character_Colorize(self, self.name)
end

-- Prefixes a name with its realm. Forever names are unique per region and its realm is only a grouping label, so they stay alone
local function GlobalPlayed_Character_AddRealmPrefix(self, p_name)
	if GlobalPlayed_Addon_IsForever() == true then
		return p_name
	end

	return self.realm .. " - " .. p_name
end

-- Returns "Realm - Name" outside Forever, for the options panel and confirmations
function GlobalPlayed_Character_GetDisplayName(self)
	return GlobalPlayed_Character_AddRealmPrefix(self, self.name)
end

-- Same as GetDisplayName with a class colored name
function GlobalPlayed_Character_GetDisplayNameColored(self)
	return GlobalPlayed_Character_AddRealmPrefix(self, GlobalPlayed_Character_GetNameColored(self))
end

-- Returns "Name-Realm" (name only on Forever), class colored when enabled, for chat
function GlobalPlayed_Character_GetNameRealmColored(self)
	if GlobalPlayed_Addon_IsForever() == true then
		return GlobalPlayed_Character_GetNameColored(self)
	end

	return GlobalPlayed_Character_Colorize(self, self.name .. "-" .. self.realm)
end

-- Returns the faction icon texture path, neutral when unknown
function GlobalPlayed_Character_GetFactionIcon(self)
	return FACTION_ICONS_PATH .. (FACTION_ICONS[self.faction] or NEUTRAL_ICON)
end

-- Returns the played time in seconds.
-- Characters saved by older versions only know their played time in hours until their next login
function GlobalPlayed_Character_GetTotalSeconds(self)
	return self.totalSeconds or ((self.totalAsHours or 0) * 3600)
end

-- Stores a played time received for this character
function GlobalPlayed_Character_UpdatePlayed(self, p_totalSeconds)
	GlobalPlayed_PlayedTime_Store(self, p_totalSeconds)
end
