----------------------
-- Addon behavior
----------------------
local currentCharacter = nil

SLASH_GLOBAL_PLAYED1 = '/gplayed'
SlashCmdList['GLOBAL_PLAYED'] = function(msg, editbox)
	if msg == "" then
		GlobalPlayed_UpdateAll()

		if GlobalPlayed_Addon_IsAceEnabled() == false then
			GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))		
		else
			GlobalPlayed_OpenUI()
		end	
	elseif msg == "all" then
		GlobalPlayed_UpdateAll()

		if GlobalPlayed_Addon_IsAceEnabled() == false then
			GlobalPlayed_LogCharactersPlayed()
			GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
		else
			GlobalPlayed_OpenUI()
		end
	elseif msg == "options" then
		GlobalPlayed_OpenOptionsPanel()
		GlobalPlayed_OpenOptionsPanel()
	else
		GlobalPlayed_Log("Unknown command: /gplayed " .. msg)
		GlobalPlayed_Log("Availaible commands:")
		GlobalPlayed_Log("    /gplayed")
		GlobalPlayed_Log("    /gplayed all")
		GlobalPlayed_Log("    /gplayed options")
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
			GlobalPlayed_AddonLoadedHandler()
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		-- Do something when player enter in world (also after loading a new place like after tp, etc...)
	end

	if event == "TIME_PLAYED_MSG" then
		local total, currentLvl = ...

		GlobalPlayed_TimePlayedMsgHandler(total, currentLvl)
	end
end

function GlobalPlayed_UpdateAll()
	if currentCharacter ~= nil then
		GlobalPlayed_Character_UpdatePlayed(currentCharacter, days, hours)
	end

	if GlobalPlayed_MyAccount ~= nil then
		GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
	end
end