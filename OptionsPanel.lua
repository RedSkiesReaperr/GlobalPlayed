local GlobalPlayedOptionsPanel = CreateFrame("Frame", "GlobalPlayedOptionsPanel");
GlobalPlayedOptionsPanel.name = "GlobalPlayed";

local category = Settings.RegisterCanvasLayoutCategory(GlobalPlayedOptionsPanel, GlobalPlayedOptionsPanel.name)
Settings.RegisterAddOnCategory(category)

local OPTIONS = {
    {
        key = "useAce",
        label = "Use Ace3 GUI",
        tooltip = "Use the Ace3 integration to display played infos in a nice windowed UI"
    },
    {
        key = "useClassColoration",
        label = "Use class colors",
        tooltip = "Use class coloration in UI, databroker, chat messages"
    },
    {
        key = "useShortDuration",
        label = "Use short duration units",
        tooltip = "Display 'd' and 'h' instead of 'days' and 'hours'"
    },
    {
        key = "useFullDuration",
        label = "Show full played time",
        tooltip = "Display minutes and seconds in addition to days and hours"
    },
    {
        key = "useFactionIcon",
        label = "Show faction icons"
    }
}

local function GlobalPlayed_CreateOptionCheck(p_parent, p_anchor, p_option, p_onChange)
    local check = CreateFrame("CheckButton", nil, p_parent, "UICheckButtonTemplate")
    check:SetSize(26, 26)
    check:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, 0)
    check.optionKey = p_option.key
    check:SetChecked(GlobalPlayed_Options[p_option.key])
    check:SetScript("OnClick", function(this)
        GlobalPlayed_Options[this.optionKey] = this:GetChecked()
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

local CHARACTER_ROW_HEIGHT = 26

local characterRows = {}
local characterList = nil

local function GlobalPlayed_CreateCharacterRow(p_index)
    local row = CreateFrame("Frame", nil, characterList)
    row:SetHeight(CHARACTER_ROW_HEIGHT)
    row:SetPoint("TOPLEFT", 0, -(p_index - 1) * CHARACTER_ROW_HEIGHT)
    row:SetPoint("RIGHT")

    row.deleteButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    row.deleteButton:SetSize(70, 22)
    row.deleteButton:SetPoint("RIGHT")
    row.deleteButton:SetText("Delete")
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

local function GlobalPlayed_RefreshCharacterList()
    local characters = GlobalPlayed_SortCharacters(GlobalPlayed_Characters, true)

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

StaticPopupDialogs["GLOBALPLAYED_DELETE_CHARACTER"] = {
    text = "Remove %s from GlobalPlayed?",
    button1 = YES,
    button2 = NO,
    OnAccept = function(self, p_character)
        GlobalPlayed_RemoveCharacter(p_character)
        GlobalPlayed_RefreshCharacterList()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

function GlobalPlayed_LoadOptionsPanel()
    GlobalPlayedOptionsPanel:SetScript("OnShow", function(self)
        local Title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        Title:SetPoint("TOPLEFT", 16, -16)
        Title:SetText(self.name)

        local SubTitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        SubTitle:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
        SubTitle:SetPoint("RIGHT", -32, 0)
        SubTitle:SetHeight(32)
        SubTitle:SetJustifyH("LEFT")
        SubTitle:SetJustifyV("TOP")
        SubTitle:SetText("See all your characters played")
        
        local checks = {}
        local anchor = SubTitle
        for _, option in ipairs(OPTIONS) do
            anchor = GlobalPlayed_CreateOptionCheck(self, anchor, option, GlobalPlayed_RefreshCharacterList)
            table.insert(checks, anchor)
        end

        local CharactersTitle = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        CharactersTitle:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -12)
        CharactersTitle:SetText("Characters")

        local CharactersHint = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        CharactersHint:SetPoint("TOPLEFT", CharactersTitle, "BOTTOMLEFT", 0, -4)
        CharactersHint:SetText("Remove characters you deleted. The logged in character cannot be removed.")

        local CharactersScroll = CreateFrame("ScrollFrame", "GlobalPlayedCharactersScroll", self, "UIPanelScrollFrameTemplate")
        CharactersScroll:SetPoint("TOPLEFT", CharactersHint, "BOTTOMLEFT", 0, -8)
        CharactersScroll:SetPoint("BOTTOMRIGHT", GlobalPlayedOptionsPanel, "BOTTOMRIGHT", -36, 64)

        characterList = CreateFrame("Frame", nil, CharactersScroll)
        characterList:SetSize(1, 1)
        CharactersScroll:SetScrollChild(characterList)
        CharactersScroll:SetScript("OnSizeChanged", function(this, width) characterList:SetWidth(width) end)

        local Disclaimer = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        Disclaimer:SetPoint("BOTTOMLEFT", GlobalPlayedOptionsPanel, "BOTTOMLEFT", 20, 20)
        Disclaimer:SetHeight(32)
        Disclaimer:SetWidth(400)
        Disclaimer:SetJustifyH("CENTER")
        Disclaimer:SetJustifyV("MIDDLE")
        Disclaimer:SetText("Disclaimer: After update some options, you may need to reload your UI through /reload or 'Save & Reload' button")

        local SaveReload = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
        SaveReload:SetPoint("BOTTOMRIGHT", GlobalPlayedOptionsPanel, "BOTTOMRIGHT", -20, 20)
        SaveReload:SetWidth(100)
        SaveReload:SetHeight(25)
        SaveReload:SetText("Save & Reload")
        SaveReload:SetScript("OnClick", function(self, button, down)
            ReloadUI()
        end)

        function self:refresh()
            for _, check in ipairs(checks) do
                check:SetChecked(GlobalPlayed_Options[check.optionKey])
            end

            GlobalPlayed_RefreshCharacterList()
        end

        self:refresh()
        self:SetScript("OnShow", function(this) this:refresh() end)
    end)
end

function GlobalPlayed_OpenOptionsPanel()
    Settings.OpenToCategory(category:GetID())
end