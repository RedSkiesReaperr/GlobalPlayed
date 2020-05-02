local AceGUI = LibStub("AceGUI-3.0")
local isUIShown = false

function OpenUI()
	if isUIShown ~= nil and isUIShown == false then
		local frame = AceGUI:Create("Frame")
		frame:SetTitle("GlobalPlayed")
		frame:SetStatusText(MyAccount:GetPlayed())
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
		local currCharacter = setmetatable(v, Character)
		local group = AceGUI:Create("InlineGroup")
		group:SetRelativeWidth(0.5)

		local characterName = AceGUI:Create("Label")
		characterName:SetText(currCharacter.name .. "-" .. currCharacter.realm)
		FormatCharacterLabel(characterName)

		local charPlayed = AceGUI:Create("Label")
		charPlayed:SetText(currCharacter:GetPlayed())
		FormatPlayedLabel(charPlayed)

		group:AddChild(characterName)
		group:AddChild(charPlayed)
		scrollFrame:AddChild(group)
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
