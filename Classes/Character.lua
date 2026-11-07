----------------------
-- Here is the Character behavior
----------------------
local FOREVER_REALM = "WoW Forever"

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

-- Saved variables are per client, so every entry of a Forever client is a Forever character
function GlobalPlayed_Character_MigrateForeverRealms()
	if GlobalPlayed_Addon_IsForever() == false then
		return
	end

	for k, v in ipairs(GlobalPlayed_Characters) do
		v.realm = FOREVER_REALM
	end
end

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

function GlobalPlayed_Character_RefreshIdentity(self)
	local _, englishClass = UnitClass("player")
	local englishFaction = UnitFactionGroup("player")

	self.class = englishClass or self.class
	self.faction = englishFaction or self.faction
end

function GlobalPlayed_Character_GetPlayed(self)
	return GlobalPlayed_PlayedTime_Format(GlobalPlayed_Character_GetTotalSeconds(self), "|cffffffff%s|r")
end

function GlobalPlayed_Character_GetPlayedWithTotal(self)
	return GlobalPlayed_PlayedTime_Format(GlobalPlayed_Character_GetTotalSeconds(self)) .. string.format(" (%sh)", self.totalAsHours)
end

function GlobalPlayed_Character_GetPlayedAsHours(self)
	return self.totalAsHours
end

function GlobalPlayed_Character_GetClassColor(self)
	return GlobalPlayed_ClassColor_GetColor(self.class)
end

-- Unknown or missing classes keep the default text color instead of breaking the display
local function GlobalPlayed_Character_Colorize(self, p_text)
	local color = GlobalPlayed_Character_GetClassColor(self)

	if GlobalPlayed_Options.useClassColoration ~= true or color == nil then
		return p_text
	end

	return "|cff" .. color .. p_text .. "|r"
end

function GlobalPlayed_Character_GetNameColored(self)
	return GlobalPlayed_Character_Colorize(self, self.name)
end

-- Forever names are unique per region and its realm value is only a grouping label
local function GlobalPlayed_Character_AddRealmPrefix(self, p_name)
	if GlobalPlayed_Addon_IsForever() == true then
		return p_name
	end

	return self.realm .. " - " .. p_name
end

function GlobalPlayed_Character_GetDisplayName(self)
	return GlobalPlayed_Character_AddRealmPrefix(self, self.name)
end

function GlobalPlayed_Character_GetDisplayNameColored(self)
	return GlobalPlayed_Character_AddRealmPrefix(self, GlobalPlayed_Character_GetNameColored(self))
end

function GlobalPlayed_Character_GetNameRealmColored(self)
	if GlobalPlayed_Addon_IsForever() == true then
		return GlobalPlayed_Character_GetNameColored(self)
	end

	return GlobalPlayed_Character_Colorize(self, self.name .. "-" .. self.realm)
end

function GlobalPlayed_Character_GetFactionIcon(self)
	local iconPath = nil

	if self.faction == "Alliance" then
		iconPath = "Interface\\AddOns\\GlobalPlayed\\Icons\\Factions\\alliance"
	elseif self.faction == "Horde" then
		iconPath = "Interface\\AddOns\\GlobalPlayed\\Icons\\Factions\\horde"
	else
		iconPath = "Interface\\AddOns\\GlobalPlayed\\Icons\\Factions\\neutral"
	end

	return iconPath
end

function GlobalPlayed_Character_GetTotalSeconds(self)
	-- Characters saved by older versions only know their played time in hours until their next login
	return self.totalSeconds or ((self.totalAsHours or 0) * 3600)
end

function GlobalPlayed_Character_UpdatePlayed(self, p_totalSeconds)
	GlobalPlayed_PlayedTime_Store(self, p_totalSeconds)
end