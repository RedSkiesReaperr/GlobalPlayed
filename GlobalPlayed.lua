----------------------
-- Slash command and game events
----------------------
-- Shows played time: the Ace3 window when enabled, otherwise a report in chat
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

SLASH_GLOBAL_PLAYED1 = "/gplayed"
-- Handles /gplayed, /gplayed all and /gplayed options, ignoring case and extra spaces
SlashCmdList["GLOBAL_PLAYED"] = function(p_message)
	local command = p_message:match("^%s*(.-)%s*$"):lower()

	if command == "" or command == "all" then
		GlobalPlayed_RequestPlayed(function() GlobalPlayed_ShowPlayed(command == "all") end)
	elseif command == "options" then
		GlobalPlayed_OpenOptionsPanel()
	else
		GlobalPlayed_Log("Unknown command: /gplayed " .. p_message)
		GlobalPlayed_Log("Available commands:")
		GlobalPlayed_Log("    /gplayed")
		GlobalPlayed_Log("    /gplayed all")
		GlobalPlayed_Log("    /gplayed options")
	end
end

local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("TIME_PLAYED_MSG")

-- Dispatches game events to their handler
eventFrame:SetScript("OnEvent", function(self, p_event, ...)
	if p_event == "ADDON_LOADED" then
		local addonName = ...

		if addonName == "GlobalPlayed" then
			self:UnregisterEvent("ADDON_LOADED")
			GlobalPlayed_AddonLoadedHandler()
		end
	elseif p_event == "PLAYER_LOGIN" then
		GlobalPlayed_PlayerLoginHandler()
	elseif p_event == "TIME_PLAYED_MSG" then
		local totalSeconds = ...

		GlobalPlayed_TimePlayedMsgHandler(totalSeconds)
	end
end)
