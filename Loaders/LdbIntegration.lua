function LoadLdbIntegration()
	local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
	local dataobj = ldb:NewDataObject("GlobalPlayed", { 
		type = "data source",
		text = "GlobalPlayed",
		OnClick = function(self, button)
			GlobalPlayed_Log(self.name)
			if self.name == "GlobalPlayed" then
				OnClickDataObj(button)
			end
		end
	})
	local f = CreateFrame("frame", "GlobalPlayedLDBFrame")

	function dataobj:OnTooltipShow()
		self:SetMinimumWidth(250)

		self:AddLine("GlobalPlayed")
		self:AddLine(" ")

		self:AddDoubleLine("Left click", "Show UI", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddLine(" ")

		local ordered = GetCharactersOrderedByRealm(Characters)
		for k, v in pairs(ordered) do
			self:AddLine(string.format("%s", k), 0.17, 0.69, 0.33)

			for kk, vv in ipairs(v) do
				self:AddDoubleLine(string.format("%s", vv.name), Character_GetPlayed(vv))
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

	function OnClickDataObj(button)
		if button == "LeftButton" then
			OpenUI()
		elseif button == "RightButton" then
			GlobalPlayed_Log("Alo")
		end
	end
end