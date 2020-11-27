local GlobalPlayedOptionsPanel = CreateFrame("Frame", "GlobalPlayedOptionsPanel", InterfaceOptionsFramePanelContainer);
GlobalPlayedOptionsPanel.name = "GlobalPlayed";
GlobalPlayedOptionsPanel.okay = function (self) self:Close(); end; 

InterfaceOptions_AddCategory(GlobalPlayedOptionsPanel);

function GlobalPlayed_LoadOptionsPanel()
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
        useAceCheck:SetChecked(GlobalPlayed_Options.useAce)
		useAceCheck:SetScript("OnClick", function(this) GlobalPlayed_Options.useAce = this:GetChecked() end)

		local enableClassColorationCheck = CreateFrame("CheckButton", "Ace", self, "InterfaceOptionsCheckButtonTemplate")
        enableClassColorationCheck:SetPoint("TOPLEFT", useAceCheck, "BOTTOMLEFT", 0, 5)
        enableClassColorationCheck.Text:SetText("Display class colors")
        enableClassColorationCheck.tooltipText = "Enable class coloration in UI, databroker, chat messages"
        enableClassColorationCheck:SetChecked(GlobalPlayed_Options.enableClassColoration)
        enableClassColorationCheck:SetScript("OnClick", function(this) GlobalPlayed_Options.enableClassColoration = this:GetChecked() end)

        local Disclaimer = self:CreateFontString("$SubTitle", "ARTWORK", "GameFontHighlightSmall")
        Disclaimer:SetPoint("BOTTOMLEFT", GlobalPlayedOptionsPanel, "BOTTOMLEFT", 20, 20)
        Disclaimer:SetHeight(32)
        Disclaimer:SetWidth(400)
        Disclaimer:SetJustifyH("CENTER")
        Disclaimer:SetJustifyV("CENTER")
        Disclaimer:SetText("Disclaimer: After update some options, you may need to reload your UI through /reload or 'Save & Reload' button")

        local SaveReload = CreateFrame("Button", "$SaveReload" , self, "UIPanelButtonTemplate")
        SaveReload:SetPoint("BOTTOMRIGHT", GlobalPlayedOptionsPanel, "BOTTOMRIGHT", -20, 20)
        SaveReload:SetWidth(100)
        SaveReload:SetHeight(25)
        SaveReload:SetText("Save & Reload")
        SaveReload:SetScript("OnClick", function(self, button, down)
            GlobalPlayedOptionsPanel:Hide()
            ReloadUI()
        end)

        function self:refresh()
			useAceCheck:SetChecked(GlobalPlayed_Options.useAce)
			enableClassColorationCheck:SetChecked(GlobalPlayed_Options.enableClassColoration)
        end

        self:refresh()
        self:SetScript("OnShow", nil)
    end)
end

function GlobalPlayed_OpenOptionsPanel()
    InterfaceOptionsFrame_OpenToCategory(GlobalPlayedOptionsPanel);
end