----------------------
-- Addon behavior
----------------------
local currentCharacter = nil

SLASH_GLOBAL_PLAYED1 = '/gplayed'
SlashCmdList['GLOBAL_PLAYED'] = function(msg, editbox)
	if msg == "" then
		LogAccountPlayed()
	elseif msg == "all" then
		LogCharactersPlayed()
	else
		Log("Unknown command: /gplayed " .. msg)
		Log("Availaible commands:")
		Log("    /gplayed")
		Log("    /gplayed all")
	end
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