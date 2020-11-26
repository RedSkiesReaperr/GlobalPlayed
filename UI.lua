local AceGUI = null
local isUIShown = null
local isUILoaded = false

-- Here are utils functions needed by the GlobalPlayed_GlobalPlayed_OpenUI function
local function GlobalPlayed_CloseUI(widget)
	isUIShown = false
	AceGUI:Release(widget)
end

local function GlobalPlayed_FormatPlayedLabel(p_label)
	local fontName, fontHeight, fontFlags = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 15)
	p_label.label:SetTextColor(0.9, 0.6, 0.2)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("BOTTOM")
end

local function GlobalPlayed_FormatCharacterLabel(p_label)
	local fontName, fontHeight, fontFlags = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 12)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("TOP")
end

local function GlobalPlayed_FillUI(p_UiFrame)
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
				GlobalPlayed_FormatCharacterLabel(characterName)

				local charPlayed = AceGUI:Create("Label")
				charPlayed:SetText(GlobalPlayed_Character_GetPlayed(currCharacter))
				GlobalPlayed_FormatPlayedLabel(charPlayed)

				group:AddChild(characterName)
				group:AddChild(charPlayed)
				scrollFrame:AddChild(group)
			end
		end
	end
end

-- Global exposed functions to load & open GlobalPlayed UI panel
function GlobalPlayed_LoadUI()
	if GlobalPlayed_Addon_IsLoaded("Ace3") == true then
		AceGUI = LibStub("AceGUI-3.0")
		isUIShown = false
		isUILoaded = true
	end
end

function GlobalPlayed_OpenUI()
	if isUILoaded == true and isUIShown ~= nil and isUIShown == false then
		local frame = AceGUI:Create("Frame")
		frame:SetTitle("GlobalPlayed")
		frame:SetStatusText(GlobalPlayed_Account_GetPlayed(MyAccount))
		frame:SetLayout("Fill")
		frame:SetCallback("OnClose", function(widget) GlobalPlayed_CloseUI(widget) end)

		isUIShown = true
		GlobalPlayed_FillUI(frame)
	end
end