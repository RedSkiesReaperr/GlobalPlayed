function GlobalPlayed_LoadLdbIntegration()
	local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
	local f = CreateFrame("frame", "GlobalPlayedLDBFrame")
	local dataobj = ldb:NewDataObject("GlobalPlayed", { 
		type = "data source",
		text = "GlobalPlayed",
		data = "Null",
		OnClick = function(self, button)
			if self.name == "GlobalPlayed" then
				if button == "LeftButton" then
					if GlobalPlayed_Addon_IsAceEnabled() == true then
						GlobalPlayed_OpenUI()
					else
						GlobalPlayed_LogCharactersPlayed()
						GlobalPlayed_Log(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
					end
				elseif button == "MiddleButton" then
					RequestTimePlayed()
					GameTooltip:Hide()
				elseif button == "RightButton" then
					GlobalPlayed_OpenOptionsPanel()
					GlobalPlayed_OpenOptionsPanel()
				end
			end
		end
	})
	
	local function GlobalPlayed_LDB_GetAccountLine(account)
		local units = GlobalPlayed_Character_GetPlayTimeUnits()
		local days = string.format("|cffffffff%d|r", account.days)
		local hours = string.format("|cffffffff%02d|r", account.hours)
		local left = "Total " .. string.format("(%dh)", account.totalAsHours)
		local playtime = string.format("%s%s %s%s", days, units.day, hours, units.hour)

		return {
			left = left,
			right = playtime
		}
	end

	local function GlobalPlayed_LDB_GetCharacterLine(character)
		local coloredName = GlobalPlayed_Character_GetNameColored(character)
		local name = coloredName .. " (" .. GlobalPlayed_Character_GetPlayedAsHours(character) .. "h)"
		local playtime = GlobalPlayed_Character_GetPlayed(character)

		return {
			name = name,
			playtime = playtime
		}
	end

	function dataobj:OnTooltipShow()
		self:SetMinimumWidth(250)

		self:AddLine("GlobalPlayed")
		self:AddLine(" ")

		if GlobalPlayed_Addon_IsAceEnabled() == true then
			self:AddDoubleLine("Left click", "Show/Hide UI", 0, 0.7, 0.8, 0, 0.7, 0.8)
		else
			self:AddDoubleLine("Left click", "Show report in chat", 0, 0.7, 0.8, 0, 0.7, 0.8)
		end
		self:AddDoubleLine("Middle click", "Refresh datas", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddDoubleLine("Right click", "Open options panel", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddLine(" ")

		local ordered = GlobalPlayed_Account_GetCharactersOrderedByRealm(GlobalPlayed_Characters)
		for k, v in pairs(ordered) do
			self:AddDoubleLine(string.format("%s:", k), string.format("Realm total: %sh", v.totalAsHours), 0.17, 0.69, 0.33, 0.17, 0.69, 0.33)

			for kk, vv in ipairs(v) do
				local characterLineTexts = GlobalPlayed_LDB_GetCharacterLine(vv)

				self:AddDoubleLine("    " .. characterLineTexts.name, characterLineTexts.playtime)
			end

			self:AddLine(" ")
		end

		self:AddLine(" ")
		local accountLine = GlobalPlayed_LDB_GetAccountLine(GlobalPlayed_MyAccount)
		self:AddDoubleLine(accountLine.left, accountLine.right)
	end

	function dataobj:OnEnter()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
		GameTooltip:ClearLines()
		dataobj.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end

	function dataobj:OnLeave()
		GameTooltip:Hide()
	end
end