----------------------
-- Options panel: settings and character management
----------------------
local L = GlobalPlayed_L

local GlobalPlayedOptionsPanel = CreateFrame("Frame", "GlobalPlayedOptionsPanel")
GlobalPlayedOptionsPanel.name = "GlobalPlayed"

local category = Settings.RegisterCanvasLayoutCategory(GlobalPlayedOptionsPanel, GlobalPlayedOptionsPanel.name)
Settings.RegisterAddOnCategory(category)

local CHARACTER_ROW_HEIGHT = 26
local DROPDOWN_WIDTH = 180
local DROPDOWN_COLUMN_X = 300

local characterRows = {}
local characterList = nil

local OPTIONS = {
	{
		key = "useWindow",
		label = L["Use the window"],
		tooltip = L["Show played time in a window. When disabled, /gplayed writes a report in chat"]
	},
	{
		key = "useClassColoration",
		label = L["Use class colors"],
		tooltip = L["Use class coloration in UI, databroker, chat messages"]
	},
	{
		key = "useShortDuration",
		label = L["Use short duration units"],
		tooltip = L["Display 'd' and 'h' instead of 'days' and 'hours'"]
	},
	{
		key = "useFullDuration",
		label = L["Show full played time"],
		tooltip = L["Display minutes and seconds in addition to days and hours"]
	},
	{
		key = "useFactionIcon",
		label = L["Show faction icons"]
	},
	{
		label = L["Show the minimap button"],
		getValue = function() return GlobalPlayed_Options.minimap.hide ~= true end,
		setValue = function(p_value) GlobalPlayed_Minimap_SetShown(p_value) end
	},
	{
		label = L["Show in the addon compartment"],
		getValue = function() return GlobalPlayed_Options.minimap.showInCompartment == true end,
		setValue = function(p_value) GlobalPlayed_Minimap_SetInCompartment(p_value) end
	}
}

-- Options shown as drop-down lists, in the right column of the panel
local DROPDOWN_OPTIONS = {
	{
		key = "brokerText",
		label = L["Broker text"],
		choices = {
			{ value = "name", label = L["Addon name"] },
			{ value = "account", label = L["Account total"] },
			{ value = "character", label = L["Current character"] }
		}
	},
	{
		key = "groupBy",
		label = L["Group characters by"],
		choices = {
			{ value = "realm", label = L["Realm"] },
			{ value = "class", label = L["Class"] },
			{ value = "faction", label = L["Faction"] }
		}
	},
	{
		key = "sortBy",
		label = L["Sort characters by"],
		choices = {
			{ value = "name", label = L["Name"] },
			{ value = "played", label = L["Played time"] }
		}
	}
}

-- Returns the current value of an option entry
local function GlobalPlayed_Options_GetValue(p_option)
	if p_option.getValue ~= nil then
		return p_option.getValue()
	end

	return GlobalPlayed_Options[p_option.key]
end

-- Stores a new value for an option entry
local function GlobalPlayed_Options_SetValue(p_option, p_value)
	if p_option.setValue ~= nil then
		p_option.setValue(p_value)
	else
		GlobalPlayed_Options[p_option.key] = p_value
	end
end

-- Creates a checkbox bound to an option below p_anchor. p_onChange runs after each click
local function GlobalPlayed_CreateOptionCheck(p_parent, p_anchor, p_option, p_onChange)
	local check = CreateFrame("CheckButton", nil, p_parent, "UICheckButtonTemplate")
	check:SetSize(26, 26)
	check:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, 0)
	check.option = p_option
	check:SetChecked(GlobalPlayed_Options_GetValue(p_option))
	check:SetScript("OnClick", function(this)
		GlobalPlayed_Options_SetValue(this.option, this:GetChecked())
		p_onChange()
	end)

	local label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetPoint("LEFT", check, "RIGHT", 4, 0)
	label:SetText(p_option.label)

	if p_option.tooltip ~= nil then
		check:SetScript("OnEnter", function(this)
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
			GameTooltip:SetText(p_option.tooltip, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		check:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	return check
end

-- Creates a labeled drop-down bound to an option below p_anchor. p_onChange runs after each choice
local function GlobalPlayed_CreateOptionDropdown(p_parent, p_anchor, p_option, p_onChange)
	local label = p_parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")

	label:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, -8)
	label:SetText(p_option.label)

	local dropdown = CreateFrame("DropdownButton", nil, p_parent, "WowStyle1DropdownTemplate")

	dropdown:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
	dropdown:SetWidth(DROPDOWN_WIDTH)
	dropdown:SetupMenu(function(_, p_rootDescription)
		for _, choice in ipairs(p_option.choices) do
			p_rootDescription:CreateRadio(choice.label, function()
				return GlobalPlayed_Options[p_option.key] == choice.value
			end, function()
				GlobalPlayed_Options[p_option.key] = choice.value
				p_onChange()
			end)
		end
	end)

	return dropdown
end

-- Creates a character row with its name, played time and delete button
local function GlobalPlayed_CreateCharacterRow(p_index)
	local row = CreateFrame("Frame", nil, characterList)
	row:SetHeight(CHARACTER_ROW_HEIGHT)
	row:SetPoint("TOPLEFT", 0, -(p_index - 1) * CHARACTER_ROW_HEIGHT)
	row:SetPoint("RIGHT")

	row.deleteButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
	row.deleteButton:SetSize(90, 22)
	row.deleteButton:SetPoint("RIGHT")
	row.deleteButton:SetText(L["Delete"])
	row.deleteButton:SetScript("OnClick", function()
		StaticPopup_Show("GLOBALPLAYED_DELETE_CHARACTER", row.displayName, nil, row.character)
	end)

	row.playedText = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	row.playedText:SetPoint("RIGHT", row.deleteButton, "LEFT", -8, 0)

	row.nameText = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	row.nameText:SetPoint("LEFT")
	row.nameText:SetPoint("RIGHT", row.playedText, "LEFT", -8, 0)
	row.nameText:SetJustifyH("LEFT")
	row.nameText:SetWordWrap(false)

	return row
end

-- Fills the character rows, reusing existing ones and hiding the extra ones
local function GlobalPlayed_RefreshCharacterList()
	local characters = GlobalPlayed_Roster_Sort(GlobalPlayed_Characters, true)

	for index, character in ipairs(characters) do
		local row = characterRows[index] or GlobalPlayed_CreateCharacterRow(index)

		characterRows[index] = row
		row.character = character
		row.displayName = GlobalPlayed_Character_GetDisplayName(character)
		row.nameText:SetText(GlobalPlayed_Character_GetDisplayNameColored(character))
		row.playedText:SetText(GlobalPlayed_Character_GetPlayedWithTotal(character))
		row.deleteButton:SetEnabled(character ~= GlobalPlayed_CurrentCharacter)
		row:Show()
	end

	for index = #characters + 1, #characterRows do
		characterRows[index]:Hide()
	end

	characterList:SetHeight(math.max(#characters * CHARACTER_ROW_HEIGHT, 1))
end

-- Applies an option change everywhere it is displayed
local function GlobalPlayed_Options_OnChanged()
	GlobalPlayed_RefreshCharacterList()
	GlobalPlayed_Broker_UpdateText()
	GlobalPlayed_Window_Update()
end

StaticPopupDialogs["GLOBALPLAYED_DELETE_CHARACTER"] = {
	text = L["Remove %s from GlobalPlayed?"],
	button1 = YES,
	button2 = NO,
	-- Removes the confirmed character and refreshes the list
	OnAccept = function(self, p_character)
		GlobalPlayed_Roster_Remove(p_character)
		GlobalPlayed_Options_OnChanged()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
}

-- Builds the panel content on first show, when saved variables are loaded
function GlobalPlayed_LoadOptionsPanel()
	GlobalPlayedOptionsPanel:SetScript("OnShow", function(self)
		local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
		title:SetPoint("TOPLEFT", 16, -16)
		title:SetText(self.name)

		local subTitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		subTitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		subTitle:SetPoint("RIGHT", -32, 0)
		subTitle:SetHeight(32)
		subTitle:SetJustifyH("LEFT")
		subTitle:SetJustifyV("TOP")
		subTitle:SetText(L["See all your characters played"])

		local checks = {}
		local anchor = subTitle
		for _, option in ipairs(OPTIONS) do
			anchor = GlobalPlayed_CreateOptionCheck(self, anchor, option, GlobalPlayed_Options_OnChanged)
			table.insert(checks, anchor)
		end

		local dropdownAnchor = CreateFrame("Frame", nil, self)

		dropdownAnchor:SetSize(1, 1)
		dropdownAnchor:SetPoint("TOPLEFT", subTitle, "BOTTOMLEFT", DROPDOWN_COLUMN_X, 0)

		for _, option in ipairs(DROPDOWN_OPTIONS) do
			dropdownAnchor = GlobalPlayed_CreateOptionDropdown(self, dropdownAnchor, option, GlobalPlayed_Options_OnChanged)
		end

		local charactersTitle = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		charactersTitle:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -12)
		charactersTitle:SetText(L["Characters"])

		if GlobalPlayed_DataStoreImport_IsAvailable() == true then
			local importButton = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")

			importButton:SetPoint("LEFT", charactersTitle, "RIGHT", 16, 0)
			importButton:SetSize(180, 22)
			importButton:SetText(L["Import from DataStore"])
			importButton:SetScript("OnClick", function()
				GlobalPlayed_DataStoreImport_Run()
				GlobalPlayed_Options_OnChanged()
			end)
		end

		local charactersHint = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		charactersHint:SetPoint("TOPLEFT", charactersTitle, "BOTTOMLEFT", 0, -4)
		charactersHint:SetText(L["Remove characters you deleted. The logged in character cannot be removed."])

		local charactersScroll = CreateFrame("ScrollFrame", "GlobalPlayedCharactersScroll", self, "UIPanelScrollFrameTemplate")
		charactersScroll:SetPoint("TOPLEFT", charactersHint, "BOTTOMLEFT", 0, -8)
		charactersScroll:SetPoint("BOTTOMRIGHT", GlobalPlayedOptionsPanel, "BOTTOMRIGHT", -36, 64)

		characterList = CreateFrame("Frame", nil, charactersScroll)
		characterList:SetSize(1, 1)
		charactersScroll:SetScrollChild(characterList)
		charactersScroll:SetScript("OnSizeChanged", function(_, p_width) characterList:SetWidth(p_width) end)

		local disclaimer = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		disclaimer:SetPoint("BOTTOMLEFT", GlobalPlayedOptionsPanel, "BOTTOMLEFT", 20, 20)
		disclaimer:SetHeight(32)
		disclaimer:SetWidth(400)
		disclaimer:SetJustifyH("CENTER")
		disclaimer:SetJustifyV("MIDDLE")
		disclaimer:SetText(L["Disclaimer: After updating some options, you may need to reload your UI through /reload or 'Save & Reload' button"])

		local saveReload = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
		saveReload:SetPoint("BOTTOMRIGHT", GlobalPlayedOptionsPanel, "BOTTOMRIGHT", -20, 20)
		saveReload:SetWidth(140)
		saveReload:SetHeight(25)
		saveReload:SetText(L["Save & Reload"])
		saveReload:SetScript("OnClick", function() ReloadUI() end)

		-- Syncs the checkboxes and the character list with the saved data
		function self:refresh()
			for _, check in ipairs(checks) do
				check:SetChecked(GlobalPlayed_Options_GetValue(check.option))
			end

			GlobalPlayed_RefreshCharacterList()
		end

		self:refresh()
		self:SetScript("OnShow", function(this) this:refresh() end)
	end)
end

-- Opens the game settings on the addon panel
function GlobalPlayed_OpenOptionsPanel()
	Settings.OpenToCategory(category:GetID())
end
