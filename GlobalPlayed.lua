----------------------
-- Addon behavior
----------------------
local currentCharacter = nil

SLASH_GLOBAL_PLAYED1 = '/gplayed'
SlashCmdList['GLOBAL_PLAYED'] = function(msg, editbox)
	if currentCharacter ~= nil then
		currentCharacter:UpdatePlayed(days, hours)
	end

	if MyAccount ~= nil then
		MyAccount:UpdatePlayed()
	end
	
	OpenUI()
end

function GlobalPlayedFrame_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("TIME_PLAYED_MSG")
end

function GlobalPlayedFrame_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...

		if addon == "GlobalPlayed" then
			AddonLoadedHandler()
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		-- Do something when player enter in world (also after loading a new place like after tp, etc...)
	end

if event == "TIME_PLAYED_MSG" then
		local total, currentLvl = ...

		TimePlayedMsgHandler(total, currentLvl)
	end
end