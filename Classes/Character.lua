----------------------
-- Here is the Character behavior
----------------------
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
	local localizedClass, englishClass = UnitClass("player")
	local englishFaction, localizedFaction = UnitFactionGroup("player")

	self.class = englishClass or self.class
	self.faction = englishFaction or self.faction
end

function GlobalPlayed_Character_GetPlayTimeUnits()
	local daysUnit, hoursUnit = nil

	if GlobalPlayed_Options.useShortDuration == true then
		daysUnit = "d"
		hoursUnit = "h"
	else
		daysUnit = "days"
		hoursUnit = "hours"
	end

	return {
		day = daysUnit,
		hour = hoursUnit
	}
end

function GlobalPlayed_Character_GetPlayed(self)
	local units = GlobalPlayed_Character_GetPlayTimeUnits()
	local hours = string.format("%02d", self.hours)

	return string.format("|cffffffff%s|r%s |cffffffff%s|r%s", self.days, units.day, hours, units.hour)
end

function GlobalPlayed_Character_GetPlayedWithTotal(self)
	local units = GlobalPlayed_Character_GetPlayTimeUnits()
	local hours = string.format("%02d", self.hours)

	return string.format("%s%s %s%s (%sh)", self.days, units.day, hours, units.hour, self.totalAsHours)
end

function GlobalPlayed_Character_GetPlayedAsHours(self)
	return self.totalAsHours
end

function GlobalPlayed_Character_GetClassColor(self)
	return GlobalPlayed_ClassColor_GetColor(self.class)
end

function GlobalPlayed_Character_GetNameColored(self)
	local classColor = nil

	if GlobalPlayed_Options.useClassColoration == true then
		classColor = "|cff" .. GlobalPlayed_Character_GetClassColor(self)
	else
		classColor = "|r"
	end

	return classColor .. self.name .. "|r"
end

function GlobalPlayed_Character_GetNameRealmColored(self)
	local classColor = nil

	if GlobalPlayed_Options.useClassColoration == true then
		classColor = "|cff" .. GlobalPlayed_Character_GetClassColor(self)
	else
		classColor = "|r"
	end

	return classColor .. self.name .. "-" .. self.realm .. "|r"
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
	self.totalSeconds = p_totalSeconds
	self.totalAsHours = math.floor(p_totalSeconds / 3600)
	self.days = math.floor(self.totalAsHours / 24)
	self.hours = self.totalAsHours - (self.days * 24)
end