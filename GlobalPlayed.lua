----------------------
-- Slash command and game events
----------------------
local L = GlobalPlayed_L

local isShowPending = false

-- Shows played time: the window when enabled, otherwise a report in chat
function GlobalPlayed_ShowPlayed(p_withCharacters)
	if GlobalPlayed_Addon_IsWindowEnabled() == true then
		GlobalPlayed_Window_Toggle()
		return
	end

	if p_withCharacters == true then
		GlobalPlayed_Roster_LogPlayed()
	end

	GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
end

-- Asks the played time, then shows it. Used by the slash command and the key binding.
-- Repeated requests are ignored until the first one is answered, so a double press does not open then close the window
function GlobalPlayed_RefreshAndShowPlayed(p_withCharacters)
	if isShowPending == true then
		return
	end

	isShowPending = true

	GlobalPlayed_RequestPlayed(function()
		isShowPending = false
		GlobalPlayed_ShowPlayed(p_withCharacters)
	end)
end

BINDING_HEADER_GLOBALPLAYED = "GlobalPlayed"
BINDING_NAME_GLOBALPLAYED_TOGGLE = L["Show or hide played time"]

SLASH_GLOBAL_PLAYED1 = "/gplayed"
-- Handles /gplayed, /gplayed all and /gplayed options, ignoring case and extra spaces
SlashCmdList["GLOBAL_PLAYED"] = function(p_message)
	local command = p_message:match("^%s*(.-)%s*$"):lower()

	if command == "" or command == "all" then
		GlobalPlayed_RefreshAndShowPlayed(command == "all")
	elseif command == "options" then
		GlobalPlayed_OpenOptionsPanel()
	else
		GlobalPlayed_Log(L["Unknown command: /gplayed "] .. p_message)
		GlobalPlayed_Log(L["Available commands:"])
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
