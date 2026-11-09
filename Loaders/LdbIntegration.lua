local HINT_COLOR = { 0, 0.7, 0.8 }
local REALM_COLOR = { 0.17, 0.69, 0.33 }
local TOOLTIP_MIN_WIDTH = 250

-- Adds a two column tooltip line with both texts in one color
local function GlobalPlayed_LDB_AddColoredLine(p_tooltip, p_left, p_right, p_color)
	local r, g, b = unpack(p_color)

	p_tooltip:AddDoubleLine(p_left, p_right, r, g, b, r, g, b)
end

-- Registers the LibDataBroker data source, its clicks and its tooltip
function GlobalPlayed_LoadLdbIntegration()
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
	local dataobj = ldb:NewDataObject("GlobalPlayed", {
		type = "data source",
		text = "GlobalPlayed",
		icon = "Interface\\AddOns\\GlobalPlayed\\Icons\\ldb_icon.jpg",
		-- Left: report or window, middle: refresh played time, right: options
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

	-- Builds the left and right texts of the account total line
	local function GlobalPlayed_LDB_GetAccountLine(p_account)
		local left = "Total " .. string.format("(%dh)", p_account.totalAsHours)
		local playtime = GlobalPlayed_PlayedTime_Format(p_account.totalSeconds or 0, "|cffffffff%s|r")

		return {
			left = left,
			right = playtime
		}
	end

	-- Builds the name and played texts of a character line
	local function GlobalPlayed_LDB_GetCharacterLine(p_character)
		local coloredName = GlobalPlayed_Character_GetNameColored(p_character)
		local name = coloredName .. " (" .. GlobalPlayed_Character_GetPlayedAsHours(p_character) .. "h)"
		local playtime = GlobalPlayed_Character_GetPlayed(p_character)

		return {
			name = name,
			playtime = playtime
		}
	end

	-- Fills the tooltip with usage hints, characters grouped by realm and the account total
	function dataobj:OnTooltipShow()
		self:SetMinimumWidth(TOOLTIP_MIN_WIDTH)

		self:AddLine("GlobalPlayed")
		self:AddLine(" ")

		if GlobalPlayed_Addon_IsWindowEnabled() == true then
			GlobalPlayed_LDB_AddColoredLine(self, "Left click", "Show/Hide UI", HINT_COLOR)
		else
			GlobalPlayed_LDB_AddColoredLine(self, "Left click", "Show report in chat", HINT_COLOR)
		end
		GlobalPlayed_LDB_AddColoredLine(self, "Middle click", "Refresh data", HINT_COLOR)
		GlobalPlayed_LDB_AddColoredLine(self, "Right click", "Open options panel", HINT_COLOR)
		self:AddLine(" ")

		local factionIcon = nil
		local realms = GlobalPlayed_Roster_GroupByRealm(GlobalPlayed_Characters)
		for k, v in ipairs(realms) do
			GlobalPlayed_LDB_AddColoredLine(self, string.format("%s:", v.realm), string.format("Realm total: %sh", v.totalAsHours), REALM_COLOR)

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

	-- Shows the tooltip for displays calling OnEnter instead of OnTooltipShow
	function dataobj:OnEnter()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
		GameTooltip:ClearLines()
		dataobj.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end

	-- Hides the tooltip
	function dataobj:OnLeave()
		GameTooltip:Hide()
	end
end
