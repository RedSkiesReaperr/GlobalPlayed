----------------------
-- Options panel: a settings page and a character management page
----------------------
local L = GlobalPlayed_L

local GlobalPlayedOptionsPanel = CreateFrame("Frame", "GlobalPlayedOptionsPanel")
GlobalPlayedOptionsPanel.name = "GlobalPlayed"

local category = Settings.RegisterCanvasLayoutCategory(GlobalPlayedOptionsPanel, GlobalPlayedOptionsPanel.name)
Settings.RegisterAddOnCategory(category)

local GlobalPlayedCharactersPanel = CreateFrame("Frame", "GlobalPlayedCharactersPanel")
Settings.RegisterCanvasLayoutSubcategory(category, GlobalPlayedCharactersPanel, L["Characters"])

local CHARACTER_ROW_HEIGHT = 26
local DROPDOWN_WIDTH = 180
local DROPDOWN_ROW_HEIGHT = 32
local DROPDOWN_X = 180
local CHECK_LABEL_GAP = 4
local SECTION_SPACING = 16

local optionChecks = {}
local characterRows = {}
local characterList = nil

-- Settings page content: an entry with choices is a drop-down list, any other entry a checkbox
local OPTION_SECTIONS = {
	{
		title = L["Display"],
		options = {
			{
				key = "useClassColoration",
				label = L["Use class colors"],
				tooltip = L["Colors character names with their class color in the window, the button tooltip, the chat report and the character list of the options."]
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
				label = L["Show faction icons"],
				tooltip = L["Shows the Alliance or Horde icon next to each character in the window and the button tooltip."]
			},
			{
				key = "groupBy",
				label = L["Group by"],
				tooltip = L["Chooses the sections that gather your characters in the window and the button tooltip."],
				choices = {
					{ value = "realm", label = L["Realm"] },
					{ value = "class", label = L["Class"] },
					{ value = "faction", label = L["Faction"] }
				}
			},
			{
				key = "sortBy",
				label = L["Sort by"],
				tooltip = L["Order of the characters in the window, the button tooltip and the chat report. Played time puts the most played first."],
				choices = {
					{ value = "name", label = L["Name"] },
					{ value = "played", label = L["Played time"] }
				}
			}
		}
	},
	{
		title = L["Access"],
		options = {
			{
				key = "useWindow",
				label = L["Use the window"],
				tooltip = L["Opens a window listing your characters. When disabled, /gplayed, the key binding and the left click on the button write a report in chat instead."]
			},
			{
				label = L["Show the minimap button"],
				tooltip = L["Shows the GlobalPlayed button on the edge of the minimap."],
				getValue = function() return GlobalPlayed_Options.minimap.hide ~= true end,
				setValue = function(p_value) GlobalPlayed_Minimap_SetShown(p_value) end
			},
			{
				label = L["Show in the minimap addon menu"],
				tooltip = L["Adds GlobalPlayed to the game's addon menu, opened from the small button with a number at the top of the minimap. Useful to hide the round button and keep an access."],
				getValue = function() return GlobalPlayed_Options.minimap.showInCompartment == true end,
				setValue = function(p_value) GlobalPlayed_Minimap_SetInCompartment(p_value) end
			},
			{
				key = "brokerText",
				label = L["Broker text"],
				tooltip = L["Text shown next to the GlobalPlayed icon in data bar addons such as Titan Panel."],
				choices = {
					{ value = "name", label = L["Addon name"] },
					{ value = "account", label = L["Account total"] },
					{ value = "character", label = L["Current character"] }
				}
			}
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

-- Shows a title and an explanation while the mouse is over p_frame.
-- Hooks the scripts because the button templates use them for their own highlight
local function GlobalPlayed_AddTooltip(p_frame, p_title, p_text)
	p_frame:HookScript("OnEnter", function(this)
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
		GameTooltip:SetText(p_title, 1, 0.82, 0)
		GameTooltip:AddLine(p_text, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	p_frame:HookScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Applies a setting change everywhere it is displayed. The character page refreshes itself when shown
local function GlobalPlayed_Options_OnChanged()
	GlobalPlayed_Broker_UpdateText()
	GlobalPlayed_Window_Update()
end

-- Creates a checkbox bound to an option below p_anchor
local function GlobalPlayed_CreateOptionCheck(p_parent, p_anchor, p_option)
	local check = CreateFrame("CheckButton", nil, p_parent, "UICheckButtonTemplate")
	check:SetSize(26, 26)
	check:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, 0)
	check.option = p_option
	check:SetScript("OnClick", function(this)
		GlobalPlayed_Options_SetValue(this.option, this:GetChecked())
		GlobalPlayed_Options_OnChanged()
	end)

	local label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetPoint("LEFT", check, "RIGHT", CHECK_LABEL_GAP, 0)
	label:SetText(p_option.label)

	-- Extends the clickable area over the label, so hovering the text shows the tooltip too
	check:SetHitRectInsets(0, -(CHECK_LABEL_GAP + label:GetStringWidth()), 0, 0)
	GlobalPlayed_AddTooltip(check, p_option.label, p_option.tooltip)

	return check
end

-- Creates a row with a label and a drop-down bound to an option below p_anchor
local function GlobalPlayed_CreateOptionDropdown(p_parent, p_anchor, p_option)
	local row = CreateFrame("Frame", nil, p_parent)

	row:SetSize(DROPDOWN_X + DROPDOWN_WIDTH, DROPDOWN_ROW_HEIGHT)
	row:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, 0)
	row:EnableMouse(true)

	local label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")

	label:SetPoint("LEFT")
	label:SetText(p_option.label)

	local dropdown = CreateFrame("DropdownButton", nil, row, "WowStyle1DropdownTemplate")

	dropdown:SetPoint("LEFT", row, "LEFT", DROPDOWN_X, 0)
	dropdown:SetWidth(DROPDOWN_WIDTH)
	dropdown:SetupMenu(function(_, p_rootDescription)
		for _, choice in ipairs(p_option.choices) do
			p_rootDescription:CreateRadio(choice.label, function()
				return GlobalPlayed_Options[p_option.key] == choice.value
			end, function()
				GlobalPlayed_Options[p_option.key] = choice.value
				GlobalPlayed_Options_OnChanged()
			end)
		end
	end)

	GlobalPlayed_AddTooltip(row, p_option.label, p_option.tooltip)
	GlobalPlayed_AddTooltip(dropdown, p_option.label, p_option.tooltip)

	return row
end

-- Creates a section title followed by its options. Returns the last control, to anchor what comes next
local function GlobalPlayed_CreateOptionSection(p_parent, p_anchor, p_section)
	local title = p_parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")

	title:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, -SECTION_SPACING)
	title:SetText(p_section.title)

	local anchor = title

	for _, option in ipairs(p_section.options) do
		if option.choices ~= nil then
			anchor = GlobalPlayed_CreateOptionDropdown(p_parent, anchor, option)
		else
			anchor = GlobalPlayed_CreateOptionCheck(p_parent, anchor, option)
			table.insert(optionChecks, anchor)
		end
	end

	return anchor
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

-- Applies a change of the character list everywhere it is displayed
local function GlobalPlayed_Options_OnCharactersChanged()
	GlobalPlayed_RefreshCharacterList()
	GlobalPlayed_Options_OnChanged()
end

StaticPopupDialogs["GLOBALPLAYED_DELETE_CHARACTER"] = {
	text = L["Remove %s from GlobalPlayed?"],
	button1 = YES,
	button2 = NO,
	-- Removes the confirmed character and refreshes the list
	OnAccept = function(self, p_character)
		GlobalPlayed_Roster_Remove(p_character)
		GlobalPlayed_Options_OnCharactersChanged()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
}

-- Creates the title and the description of a page. Returns the description, to anchor the content
local function GlobalPlayed_CreatePageHeader(p_page, p_title, p_description)
	local title = p_page:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(p_title)

	local description = p_page:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	description:SetPoint("RIGHT", -32, 0)
	description:SetJustifyH("LEFT")
	description:SetText(p_description)

	return description
end

-- Builds the settings page
local function GlobalPlayed_BuildSettingsPage(p_page)
	local anchor = GlobalPlayed_CreatePageHeader(p_page, p_page.name, L["See all your characters played"])

	for _, section in ipairs(OPTION_SECTIONS) do
		anchor = GlobalPlayed_CreateOptionSection(p_page, anchor, section)
	end
end

-- Syncs the checkboxes with the saved options
local function GlobalPlayed_RefreshOptionChecks()
	for _, check in ipairs(optionChecks) do
		check:SetChecked(GlobalPlayed_Options_GetValue(check.option))
	end
end

-- Builds the character management page
local function GlobalPlayed_BuildCharactersPage(p_page)
	local description = GlobalPlayed_CreatePageHeader(p_page, L["Characters"], L["Remove characters you deleted. The logged in character cannot be removed."])

	if GlobalPlayed_DataStoreImport_IsAvailable() == true then
		local importButton = CreateFrame("Button", nil, p_page, "UIPanelButtonTemplate")

		importButton:SetPoint("TOPRIGHT", -36, -16)
		importButton:SetSize(180, 22)
		importButton:SetText(L["Import from DataStore"])
		importButton:SetScript("OnClick", function()
			GlobalPlayed_DataStoreImport_Run()
			GlobalPlayed_Options_OnCharactersChanged()
		end)
		GlobalPlayed_AddTooltip(importButton, L["Import from DataStore"], L["Adds the characters known by DataStore or Altoholic that are missing from this list. For the others, keeps the highest played time."])
	end

	local charactersScroll = CreateFrame("ScrollFrame", "GlobalPlayedCharactersScroll", p_page, "UIPanelScrollFrameTemplate")
	charactersScroll:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -12)
	charactersScroll:SetPoint("BOTTOMRIGHT", p_page, "BOTTOMRIGHT", -36, 16)

	characterList = CreateFrame("Frame", nil, charactersScroll)
	characterList:SetSize(1, 1)
	charactersScroll:SetScrollChild(characterList)
	charactersScroll:SetScript("OnSizeChanged", function(_, p_width) characterList:SetWidth(p_width) end)
	-- The scroll frame may already have its size here, and OnSizeChanged would then not fire on the first show
	characterList:SetWidth(charactersScroll:GetWidth())
end

-- Builds a page on its first show, when saved variables are loaded, then only refreshes it
local function GlobalPlayed_SetupPage(p_page, p_build, p_refresh)
	p_page:SetScript("OnShow", function(this)
		p_build(this)
		p_refresh()
		this:SetScript("OnShow", p_refresh)
	end)
end

-- Prepares both pages of the panel
function GlobalPlayed_LoadOptionsPanel()
	GlobalPlayed_SetupPage(GlobalPlayedOptionsPanel, GlobalPlayed_BuildSettingsPage, GlobalPlayed_RefreshOptionChecks)
	GlobalPlayed_SetupPage(GlobalPlayedCharactersPanel, GlobalPlayed_BuildCharactersPage, GlobalPlayed_RefreshCharacterList)
end

-- Opens the game settings on the addon panel
function GlobalPlayed_OpenOptionsPanel()
	Settings.OpenToCategory(category:GetID())
end
