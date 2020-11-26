function GlobalPlayed_LoadLdbIntegration()
	local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
	local f = CreateFrame("frame", "GlobalPlayedLDBFrame")
	local dataobj = ldb:NewDataObject("GlobalPlayed", { 
		type = "data source",
		text = "GlobalPlayed",
		data = "NUll",
		OnClick = function(self, button)
			if self.name == "GlobalPlayed" then
				if button == "LeftButton" then
					if GlobalPlayed_Addon_IsAceEnabled() == true then
						GlobalPlayed_OpenUI()
					else
						GlobalPlayed_LogCharactersPlayed()
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

		local ordered = GlobalPlayed_GetCharactersOrderedByRealm(Characters)
		for k, v in pairs(ordered) do
			self:AddLine(string.format("%s", k), 0.17, 0.69, 0.33)

			for kk, vv in ipairs(v) do
				self:AddDoubleLine(string.format("%s", vv.name), GlobalPlayed_Character_GetPlayed(vv))
			end

			self:AddLine(" ")
		end

		self:AddLine(" ")
		self:AddDoubleLine(string.format("Total:"), string.format("%d days %d hours (%dh)", MyAccount.days, MyAccount.hours, MyAccount.totalAsHours))
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