local L = GlobalPlayed_L

local HINT_COLOR = { 0, 0.7, 0.8 }
local GROUP_HEADER_COLOR = { 0.17, 0.69, 0.33 }
local TOOLTIP_MIN_WIDTH = 250
local BROKER_NAME = "GlobalPlayed"
local BROKER_ICON = "Interface\\Icons\\INV_Misc_PocketWatch_01"

local brokerObject = nil

-- Adds a two column tooltip line with both texts in one color
local function GlobalPlayed_LDB_AddColoredLine(p_tooltip, p_left, p_right, p_color)
	local r, g, b = unpack(p_color)

	p_tooltip:AddDoubleLine(p_left, p_right, r, g, b, r, g, b)
end

-- Returns the text matching the broker text option
local function GlobalPlayed_Broker_GetText()
	if GlobalPlayed_Options.brokerText == "account" then
		return GlobalPlayed_PlayedTime_Format(GlobalPlayed_MyAccount.totalSeconds)
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

-- Returns the left and right texts of the account total line
local function GlobalPlayed_LDB_GetAccountLine(p_account)
	local left = L["Total"] .. GlobalPlayed_PlayedTime_FormatHoursSuffix(p_account.totalAsHours)
	local right = GlobalPlayed_PlayedTime_Format(p_account.totalSeconds, "|cffffffff%s|r")

	return left, right
end

-- Returns the name and played texts of a character line
local function GlobalPlayed_LDB_GetCharacterLine(p_character)
	local name = GlobalPlayed_Character_GetListName(p_character) .. GlobalPlayed_PlayedTime_FormatHoursSuffix(GlobalPlayed_Character_GetPlayedAsHours(p_character))

	return name, GlobalPlayed_Character_GetPlayed(p_character)
end

-- Registers the LibDataBroker data source, its clicks, its tooltip and its minimap button
function GlobalPlayed_LoadLdbIntegration()
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
	local dataobj = ldb:NewDataObject(BROKER_NAME, {
		type = "data source",
		text = BROKER_NAME,
		icon = BROKER_ICON,
		-- Left: report or window, middle: refresh played time, right: options
		OnClick = function(_, p_button)
			if p_button == "LeftButton" then
				GlobalPlayed_ShowPlayed(true)
			elseif p_button == "MiddleButton" then
				GlobalPlayed_RequestPlayed()
				GameTooltip:Hide()
			elseif p_button == "RightButton" then
				GlobalPlayed_OpenOptionsPanel()
			end
		end
	})

	brokerObject = dataobj
	GlobalPlayed_Broker_UpdateText()

	LibStub("LibDBIcon-1.0"):Register(BROKER_NAME, dataobj, GlobalPlayed_Options.minimap)

	-- Fills the tooltip with usage hints, grouped characters and the account total
	function dataobj:OnTooltipShow()
		self:SetMinimumWidth(TOOLTIP_MIN_WIDTH)

		self:AddLine(BROKER_NAME)
		self:AddLine(" ")

		if GlobalPlayed_Addon_IsWindowEnabled() == true then
			GlobalPlayed_LDB_AddColoredLine(self, L["Left click"], L["Show/Hide UI"], HINT_COLOR)
		else
			GlobalPlayed_LDB_AddColoredLine(self, L["Left click"], L["Show report in chat"], HINT_COLOR)
		end
		GlobalPlayed_LDB_AddColoredLine(self, L["Middle click"], L["Refresh data"], HINT_COLOR)
		GlobalPlayed_LDB_AddColoredLine(self, L["Right click"], L["Open options panel"], HINT_COLOR)
		self:AddLine(" ")

		local groups = GlobalPlayed_Roster_Group(GlobalPlayed_Characters)
		for _, group in ipairs(groups) do
			GlobalPlayed_LDB_AddColoredLine(self, string.format("%s:", group.label), string.format(L["Total: %sh"], group.totalAsHours), GROUP_HEADER_COLOR)

			for _, character in ipairs(group.characters) do
				local name, played = GlobalPlayed_LDB_GetCharacterLine(character)

				if GlobalPlayed_Options.useFactionIcon == true then
					local factionIcon = GlobalPlayed_Character_GetFactionIcon(character)

					self:AddDoubleLine("|T" .. factionIcon .. ":16:16:2:0|t  " .. name, played)
				else
					self:AddDoubleLine("    " .. name, played)
				end
			end

			self:AddLine(" ")
		end

		self:AddLine(" ")
		self:AddDoubleLine(GlobalPlayed_LDB_GetAccountLine(GlobalPlayed_MyAccount))
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
