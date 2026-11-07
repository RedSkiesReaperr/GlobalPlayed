function GlobalPlayed_LoadLdbIntegration()
	local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
	local dataobj = ldb:NewDataObject("GlobalPlayed", { 
		type = "data source",
		text = "GlobalPlayed",
		icon = "Interface\\AddOns\\GlobalPlayed\\Icons\\ldb_icon.jpg",
		OnClick = function(self, button)
			if button == "LeftButton" then
				GlobalPlayed_ShowPlayed(true)
			elseif button == "MiddleButton" then
				GlobalPlayed_RequestPlayed()
				GameTooltip:Hide()
			elseif button == "RightButton" then
				GlobalPlayed_OpenOptionsPanel()
			end
		end
	})
	
	local function GlobalPlayed_LDB_GetAccountLine(account)
		local left = "Total " .. string.format("(%dh)", account.totalAsHours)
		local playtime = GlobalPlayed_PlayedTime_Format(account.totalSeconds or 0, "|cffffffff%s|r")

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
		self:AddDoubleLine("Middle click", "Refresh data", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddDoubleLine("Right click", "Open options panel", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddLine(" ")

		local factionIcon = nil
		local realms = GlobalPlayed_Roster_GroupByRealm(GlobalPlayed_Characters)
		for k, v in ipairs(realms) do
			self:AddDoubleLine(string.format("%s:", v.realm), string.format("Realm total: %sh", v.totalAsHours), 0.17, 0.69, 0.33, 0.17, 0.69, 0.33)

			for kk, vv in ipairs(v.characters) do
				local characterLineTexts = GlobalPlayed_LDB_GetCharacterLine(vv)

				if GlobalPlayed_Options.useFactionIcon == true then
					factionIcon = GlobalPlayed_Character_GetFactionIcon(vv)
					self:AddDoubleLine("|T" .. factionIcon .. ":16:16:2:0|t  " .. characterLineTexts.name, characterLineTexts.playtime)
				else
					self:AddDoubleLine("    " .. characterLineTexts.name, characterLineTexts.playtime)
				end
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