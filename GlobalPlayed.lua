----------------------
-- Addon behavior
----------------------
local currentCharacter = nil

SLASH_GLOBAL_PLAYED1 = '/gplayed'
SlashCmdList['GLOBAL_PLAYED'] = function(msg, editbox)
	if msg == "" then
		UpdateAll()

		if Addon_IsAceEnabled() == false then
			GlobalPlayed_Log(Account_GetPlayed(MyAccount))		
		else
			OpenUI()
		end	
	elseif msg == "all" then
		UpdateAll()

		if Addon_IsAceEnabled() == false then
			GlobalPlayed_LogCharactersPlayed()
			GlobalPlayed_Log(Account_GetPlayed(MyAccount))
		else
			OpenUI()
		end
	elseif msg == "options" then
		OpenOptions()
		OpenOptions()
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

function UpdateAll()
	if currentCharacter ~= nil then
		Character_UpdatePlayed(currentCharacter, days, hours)
	end

	if MyAccount ~= nil then
		Account_UpdatePlayed(MyAccount)
	end
end