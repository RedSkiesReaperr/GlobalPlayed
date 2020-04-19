----------------------
-- Classes
----------------------
Character = {}
Character.__index = Character

function Character:new(p_name)
	local newChar = {
		name = p_name,
		days = 0,
		hours = 0
	}
	setmetatable(newChar, Character)
	return newChar
end

----------------------
-- Utils functions
----------------------
function Log(message)
	print("[GlobalPlayed] " .. message)
end

----------------------
-- Characters functions
----------------------
function FindCharacterByName(p_name)
	if Characters == nil then
		return nil
	end

	for k, v in ipairs(Characters) do
		if v.name == p_name then
			return v
		end
	end
	
	return nil
end

function UpdateTotalPlayed()
	local days = 0
	local hours = 0

	if Characters == nil then
		return nil
	end

	for k, v in ipairs(Characters) do
		if v.days ~= nil and v.days > 0 then
			days = days + v.days
		end

		if v.hours ~= nil and v.hours > 0 then
			hours = hours + v.hours
		end
	end

	local nbOfDays = math.floor(hours / 24)
	
	TotalDays = days + nbOfDays
	TotalHours = hours - (nbOfDays * 24)
	TotalAsHours = (TotalDays * 24) + TotalHours
	Log("Total: " .. TotalDays .. " days " .. TotalHours .. " hours (" .. TotalAsHours .. "h)")
end

---------------------
-- Addon main() behavior
----------------------
function Main()
	Log("Successfully loaded!")
end

----------------------
-- Addon behavior
----------------------
Main()

local frame = CreateFrame("Frame")
local currentCharacter = nil

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("TIME_PLAYED_MSG")

frame:SetScript("OnEvent", function(self, event, ...)
	local addon = ...

	if event == "ADDON_LOADED" then
		if addon == "GlobalPlayed" then
			if Characters == nil then -- If no characters registered
				Characters = {  }
			end

			searchResult = FindCharacterByName(UnitName("player"))

			if searchResult == nil then
				currentCharacter = Character:new(UnitName("player"))
				table.insert(Characters, currentCharacter)
			else
				currentCharacter = searchResult
			end

			UpdateTotalPlayed()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		-- Do something when player enter in world (also after loading a new place like after tp, etc...)
	end

	if event == "TIME_PLAYED_MSG" then
		local total, currentLvl = ...
		local totalAsInt = tonumber(total)

		local days = math.floor(totalAsInt / 86400);
		totalAsInt = totalAsInt - (days * 86400);

		local hours = math.floor(totalAsInt / 3600);
		totalAsInt = totalAsInt - (hours * 3600);

		currentCharacter.days = days
		currentCharacter.hours = hours

		UpdateTotalPlayed()
	end
end)