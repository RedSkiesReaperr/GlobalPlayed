local AceGUI = null
local isUIShown = null
local isUILoaded = false
local uiFrame = nil

-- Here are utils functions needed by the GlobalPlayed_GlobalPlayed_OpenUI function
local function GlobalPlayed_CloseUI(widget)
	isUIShown = false
	AceGUI:Release(widget)
end

local function GlobalPlayed_FormatRealmNameLabel(p_label)
	local fontName, fontHeight, fontFlags = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 16)
	p_label.label:SetTextColor(0.17, 0.69, 0.33)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("BOTTOM")
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

	local ordered = GlobalPlayed_Account_GetCharactersOrderedByRealm(GlobalPlayed_Characters)

	for k, v in pairs(ordered) do
		if v ~= nil then
			local realmName = AceGUI:Create("Label")
			realmName:SetText(k .. string.format(" (%sh)", v.totalAsHours))
			GlobalPlayed_FormatRealmNameLabel(realmName)
			scrollFrame:AddChild(realmName)

			for kk, currCharacter in ipairs(v) do
				local coloredNameRealm = GlobalPlayed_Character_GetNameColored(currCharacter)
				local group = AceGUI:Create("InlineGroup")
				group:SetLayout("List")
				group:SetRelativeWidth(0.5)
	
				if currCharacter ~=nil and currCharacter.name ~= nil and currCharacter.realm ~= nil then
					local characterName = AceGUI:Create("Label")
					characterName:SetText(coloredNameRealm)
					GlobalPlayed_FormatCharacterLabel(characterName)
	
					local charPlayed = AceGUI:Create("Label")
					if GlobalPlayed_Options.useFactionIcon == true then
						charPlayed:SetImage(GlobalPlayed_Character_GetFactionIcon(currCharacter))
						charPlayed:SetImageSize(15, 15)
					end
					charPlayed:SetText(GlobalPlayed_Character_GetPlayedWithTotal(currCharacter))
					GlobalPlayed_FormatPlayedLabel(charPlayed)
	
					group:AddChild(characterName)
					group:AddChild(charPlayed)
					scrollFrame:AddChild(group)
				end
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
	if isUIShown == false then
		uiFrame = AceGUI:Create("Frame")
		uiFrame:SetTitle("GlobalPlayed")
		uiFrame:SetStatusText(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
		uiFrame:SetLayout("Fill")
		uiFrame:SetCallback("OnClose", function(widget) GlobalPlayed_CloseUI(widget) end)

		isUIShown = true
		GlobalPlayed_FillUI(uiFrame)
	else
		GlobalPlayed_CloseUI(uiFrame)
	end
end