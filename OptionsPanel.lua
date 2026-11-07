local GlobalPlayedOptionsPanel = CreateFrame("Frame", "GlobalPlayedOptionsPanel");
GlobalPlayedOptionsPanel.name = "GlobalPlayed";
GlobalPlayedOptionsPanel.close = function (self) self:Close(); end;

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
        key = "useFactionIcon",
        label = "Show faction icons"
    }
}

local function GlobalPlayed_CreateOptionCheck(p_parent, p_anchor, p_option)
    local check = CreateFrame("CheckButton", nil, p_parent, "UICheckButtonTemplate")
    check:SetSize(26, 26)
    check:SetPoint("TOPLEFT", p_anchor, "BOTTOMLEFT", 0, 0)
    check.optionKey = p_option.key
    check:SetChecked(GlobalPlayed_Options[p_option.key])
    check:SetScript("OnClick", function(this) GlobalPlayed_Options[this.optionKey] = this:GetChecked() end)

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

function GlobalPlayed_LoadOptionsPanel()
    GlobalPlayedOptionsPanel:SetScript("OnShow", function(self)
        local Title = self:CreateFontString(GlobalPlayedOptionsPanel.name, "ARTWORK", "GameFontNormalHuge")
        Title:SetPoint("TOPLEFT", 16, -16)
        Title:SetText(self.name)

        local SubTitle = self:CreateFontString("$SubTitle", "ARTWORK", "GameFontHighlightSmall")
        SubTitle:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
        SubTitle:SetPoint("RIGHT", -32, 0)
        SubTitle:SetHeight(32)
        SubTitle:SetJustifyH("LEFT")
        SubTitle:SetJustifyV("TOP")
        SubTitle:SetText("See all your characters played")
        
        local checks = {}
        local anchor = SubTitle
        for _, option in ipairs(OPTIONS) do
            anchor = GlobalPlayed_CreateOptionCheck(self, anchor, option)
            table.insert(checks, anchor)
        end

        local Disclaimer = self:CreateFontString("$SubTitle", "ARTWORK", "GameFontHighlightSmall")
        Disclaimer:SetPoint("BOTTOMLEFT", GlobalPlayedOptionsPanel, "BOTTOMLEFT", 20, 20)
        Disclaimer:SetHeight(32)
        Disclaimer:SetWidth(400)
        Disclaimer:SetJustifyH("CENTER")
        Disclaimer:SetJustifyV("MIDDLE")
        Disclaimer:SetText("Disclaimer: After update some options, you may need to reload your UI through /reload or 'Save & Reload' button")

        local SaveReload = CreateFrame("Button", "$SaveReload" , self, "UIPanelButtonTemplate")
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
        end

        self:refresh()
        self:SetScript("OnShow", nil)
    end)
end

function GlobalPlayed_OpenOptionsPanel()
    Settings.OpenToCategory(category:GetID())
end