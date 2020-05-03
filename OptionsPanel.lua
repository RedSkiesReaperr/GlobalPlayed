GlobalPlayedOptionsPanel = CreateFrame("Frame", "GlobalPlayedOptionsPanel", InterfaceOptionsFramePanelContainer);
GlobalPlayedOptionsPanel.name = "GlobalPlayed";
GlobalPlayedOptionsPanel.okay = function (self) self:Close(); end; 
InterfaceOptions_AddCategory(GlobalPlayedOptionsPanel);

GlobalPlayedOptionsPanel:SetScript("OnShow", function(self)
    local Title = self:CreateFontString("GlobalPlayed", "ARTWORK", "GameFontNormalHuge")
	Title:SetPoint("TOPLEFT", 16, -16)
	Title:SetText(self.name)

    local SubTitle = self:CreateFontString("$SubTitle", "ARTWORK", "GameFontHighlightSmall")
	SubTitle:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
	SubTitle:SetPoint("RIGHT", -32, 0)
	SubTitle:SetHeight(32)
	SubTitle:SetJustifyH("LEFT")
	SubTitle:SetJustifyV("TOP")
    SubTitle:SetText("See all your characters played")
    
    local useAceCheck = CreateFrame("CheckButton", "Ace", self, "InterfaceOptionsCheckButtonTemplate")
	useAceCheck:SetPoint("TOPLEFT", SubTitle, "BOTTOMLEFT", 0, 5)
	useAceCheck.Text:SetText("Use Ace3 GUI")
    useAceCheck.tooltipText = "Use the Ace3 integration to display played infos in a nice windowed UI"
    useAceCheck:SetChecked(Options.useAce)
    useAceCheck:SetScript("OnClick", function(this) Options.useAce = this:GetChecked() end)

    local Disclaimer = self:CreateFontString("$SubTitle", "ARTWORK", "GameFontHighlightSmall")
	Disclaimer:SetPoint("TOPRIGHT", InterfaceOptionsFrameCancel, "TOPRIGHT", -170, 55)
    Disclaimer:SetHeight(32)
    Disclaimer:SetWidth(400)
	Disclaimer:SetJustifyH("CENTER")
	Disclaimer:SetJustifyV("CENTER")
    Disclaimer:SetText("Disclaimer: After update some options, you may need to reload your UI through /reload or 'Save & Reload' button")

    local SaveReload = CreateFrame("Button", "$SaveReload" , self, "UIPanelButtonTemplate")
	SaveReload:SetPoint("TOPRIGHT", InterfaceOptionsFrameCancel, "TOPRIGHT", -15, 50)
	SaveReload:SetWidth(100)
	SaveReload:SetHeight(25)
	SaveReload:SetText("Save & Reload")
	SaveReload:SetScript("OnClick", function(self, button, down)
        GlobalPlayedOptionsPanel:Hide()
        ReloadUI()
    end)

    function self:refresh()
        useAceCheck:SetChecked(Options.useAce)
    end

    self:refresh()
    self:SetScript("OnShow", nil)
end)

function OpenOptions()
    InterfaceOptionsFrame_OpenToCategory(GlobalPlayedOptionsPanel);
end

function UseAceGui()
    return (IsAddOnLoaded("Ace3") == true and Options.useAce == true)
end