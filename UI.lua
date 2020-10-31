local AceGUI = null
local isUIShown = null
local isUILoaded = false

function LoadUI()
	if Addon_IsLoaded("Ace3") == true then
		AceGUI = LibStub("AceGUI-3.0")
		isUIShown = false
		isUILoaded = true
	end
end

function OpenUI()
	if isUILoaded == true and isUIShown ~= nil and isUIShown == false then
		local frame = AceGUI:Create("Frame")
		frame:SetTitle("GlobalPlayed")
		frame:SetStatusText(Account_GetPlayed(MyAccount))
		frame:SetLayout("Fill")
		frame:SetCallback("OnClose", function(widget) CloseUI(widget) end)

		isUIShown = true
		FillUI(frame)
	end
end

function FillUI(p_UiFrame)
	local scrollFrame = AceGUI:Create("ScrollFrame")
	scrollFrame:SetLayout("Flow")
	p_UiFrame:AddChild(scrollFrame)

	for k, v in ipairs(Characters) do
		if v ~= nil then
			local currCharacter = v

			if currCharacter ~=nil and currCharacter.name ~= nil and currCharacter.realm ~= nil then
				local group = AceGUI:Create("InlineGroup")
				group:SetRelativeWidth(0.5)

				local characterName = AceGUI:Create("Label")
				characterName:SetText(currCharacter.name .. "-" .. currCharacter.realm)
				FormatCharacterLabel(characterName)

				local charPlayed = AceGUI:Create("Label")
				charPlayed:SetText(Character_GetPlayed(currCharacter))
				FormatPlayedLabel(charPlayed)

				group:AddChild(characterName)
				group:AddChild(charPlayed)
				scrollFrame:AddChild(group)
			end
		end
	end
end

function FormatCharacterLabel(p_label)
	local fontName, fontHeight, fontFlags = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 12)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("TOP")
end

function FormatPlayedLabel(p_label)
	local fontName, fontHeight, fontFlags = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 15)
	p_label.label:SetTextColor(0.9, 0.6, 0.2)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("BOTTOM")
end

function CloseUI(widget)
	isUIShown = false
	AceGUI:Release(widget)
end