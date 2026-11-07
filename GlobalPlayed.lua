----------------------
-- Addon behavior
----------------------
SLASH_GLOBAL_PLAYED1 = '/gplayed'
SlashCmdList['GLOBAL_PLAYED'] = function(msg)
	if msg == "" then
		GlobalPlayed_RequestPlayed(function()
			if GlobalPlayed_Addon_IsAceEnabled() == false then
				GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
			else
				GlobalPlayed_OpenUI()
			end
		end)
	elseif msg == "all" then
		GlobalPlayed_RequestPlayed(function()
			if GlobalPlayed_Addon_IsAceEnabled() == false then
				GlobalPlayed_Roster_LogPlayed()
				GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
			else
				GlobalPlayed_OpenUI()
			end
		end)
	elseif msg == "options" then
		GlobalPlayed_OpenOptionsPanel()
	else
		GlobalPlayed_Log("Unknown command: /gplayed " .. msg)
		GlobalPlayed_Log("Available commands:")
		GlobalPlayed_Log("    /gplayed")
		GlobalPlayed_Log("    /gplayed all")
		GlobalPlayed_Log("    /gplayed options")
	end
end

function GlobalPlayedFrame_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("TIME_PLAYED_MSG")
end

function GlobalPlayedFrame_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...

		if addon == "GlobalPlayed" then
			GlobalPlayed_AddonLoadedHandler()
		end
	end

	if event == "PLAYER_LOGIN" then
		GlobalPlayed_PlayerLoginHandler()
	end

	if event == "TIME_PLAYED_MSG" then
		local totalSeconds = ...

		GlobalPlayed_TimePlayedMsgHandler(totalSeconds)
	end
end