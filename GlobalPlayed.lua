----------------------
-- Addon behavior
----------------------
-- The Ace3 window when enabled, otherwise a report in chat
function GlobalPlayed_ShowPlayed(p_withCharacters)
	if GlobalPlayed_Addon_IsAceEnabled() == true then
		GlobalPlayed_OpenUI()
		return
	end

	if p_withCharacters == true then
		GlobalPlayed_Roster_LogPlayed()
	end

	GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
end

SLASH_GLOBAL_PLAYED1 = '/gplayed'
SlashCmdList['GLOBAL_PLAYED'] = function(msg)
	local command = msg:match("^%s*(.-)%s*$"):lower()

	if command == "" or command == "all" then
		GlobalPlayed_RequestPlayed(function() GlobalPlayed_ShowPlayed(command == "all") end)
	elseif command == "options" then
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