local L = GlobalPlayed_L

local HINT_COLOR = { 0, 0.7, 0.8 }
local REALM_COLOR = { 0.17, 0.69, 0.33 }
local TOOLTIP_MIN_WIDTH = 250
local BROKER_NAME = "GlobalPlayed"

local brokerObject = nil

-- Adds a two column tooltip line with both texts in one color
local function GlobalPlayed_LDB_AddColoredLine(p_tooltip, p_left, p_right, p_color)
	local r, g, b = unpack(p_color)

	p_tooltip:AddDoubleLine(p_left, p_right, r, g, b, r, g, b)
end

-- Returns the text matching the broker text option
local function GlobalPlayed_Broker_GetText()
	if GlobalPlayed_Options.brokerText == "account" then
		return GlobalPlayed_PlayedTime_Format(GlobalPlayed_MyAccount.totalSeconds or 0)
	end

	if GlobalPlayed_Options.brokerText == "character" and GlobalPlayed_CurrentCharacter ~= nil then
		return GlobalPlayed_PlayedTime_Format(GlobalPlayed_Character_GetTotalSeconds(GlobalPlayed_CurrentCharacter))
	end

	return BROKER_NAME
end

-- Updates the text shown by display addons such as Titan Panel or ElvUI
function GlobalPlayed_Broker_UpdateText()
	if brokerObject ~= nil then
		brokerObject.text = GlobalPlayed_Broker_GetText()
	end
end

-- Shows or hides the minimap button and remembers the choice
function GlobalPlayed_Minimap_SetShown(p_shown)
	local icon = LibStub("LibDBIcon-1.0")

	GlobalPlayed_Options.minimap.hide = not p_shown

	if p_shown == true then
		icon:Show(BROKER_NAME)
	else
		icon:Hide(BROKER_NAME)
	end
end

-- Adds or removes the addon compartment entry. LibDBIcon remembers the choice
function GlobalPlayed_Minimap_SetInCompartment(p_inCompartment)
	local icon = LibStub("LibDBIcon-1.0")

	if p_inCompartment == true then
		icon:AddButtonToCompartment(BROKER_NAME)
	else
		icon:RemoveButtonFromCompartment(BROKER_NAME)
	end
end

-- Registers the LibDataBroker data source, its clicks, its tooltip and its minimap button
function GlobalPlayed_LoadLdbIntegration()
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
	local dataobj = ldb:NewDataObject(BROKER_NAME, {
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

	brokerObject = dataobj
	GlobalPlayed_Broker_UpdateText()

	LibStub("LibDBIcon-1.0"):Register(BROKER_NAME, dataobj, GlobalPlayed_Options.minimap)

	-- Builds the left and right texts of the account total line
	local function GlobalPlayed_LDB_GetAccountLine(p_account)
		local left = L["Total"] .. string.format(" (%dh)", p_account.totalAsHours)
		local playtime = GlobalPlayed_PlayedTime_Format(p_account.totalSeconds or 0, "|cffffffff%s|r")

		return {
			left = left,
			right = playtime
		}
	end

	-- Builds the name and played texts of a character line
	local function GlobalPlayed_LDB_GetCharacterLine(p_character)
		local coloredName = GlobalPlayed_Character_GetListName(p_character)
		local name = coloredName .. " (" .. GlobalPlayed_Character_GetPlayedAsHours(p_character) .. "h)"
		local playtime = GlobalPlayed_Character_GetPlayed(p_character)

		return {
			name = name,
			playtime = playtime
		}
	end

	-- Fills the tooltip with usage hints, grouped characters and the account total
	function dataobj:OnTooltipShow()
		self:SetMinimumWidth(TOOLTIP_MIN_WIDTH)

		self:AddLine("GlobalPlayed")
		self:AddLine(" ")

		if GlobalPlayed_Addon_IsWindowEnabled() == true then
			GlobalPlayed_LDB_AddColoredLine(self, L["Left click"], L["Show/Hide UI"], HINT_COLOR)
		else
			GlobalPlayed_LDB_AddColoredLine(self, L["Left click"], L["Show report in chat"], HINT_COLOR)
		end
		GlobalPlayed_LDB_AddColoredLine(self, L["Middle click"], L["Refresh data"], HINT_COLOR)
		GlobalPlayed_LDB_AddColoredLine(self, L["Right click"], L["Open options panel"], HINT_COLOR)
		self:AddLine(" ")

		local factionIcon = nil
		local groups = GlobalPlayed_Roster_Group(GlobalPlayed_Characters)
		for k, v in ipairs(groups) do
			GlobalPlayed_LDB_AddColoredLine(self, string.format("%s:", v.label), string.format(L["Total: %sh"], v.totalAsHours), REALM_COLOR)

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
