local AceGUI = nil
local isUIShown = nil
local uiFrame = nil

local CARDS_LAYOUT = "GlobalPlayedCards"
local CARD_MIN_WIDTH = 230
local MAX_COLUMNS = 4
local FRAME_MIN_WIDTH = 400
local FRAME_MIN_HEIGHT = 300
-- AceGUI recycles its frames, so the default bounds are restored on close
local ACEGUI_FRAME_MIN_WIDTH = 400
local ACEGUI_FRAME_MIN_HEIGHT = 200

local function GlobalPlayed_GetColumnCount(p_width)
	return math.max(1, math.min(MAX_COLUMNS, math.floor(p_width / CARD_MIN_WIDTH)))
end

-- Flow layout with as many card columns as the width allows, run by AceGUI on every resize
local function GlobalPlayed_CardsLayout(p_content, p_children)
	local width = p_content.width or p_content:GetWidth() or 0
	local columnWidth = 1 / GlobalPlayed_GetColumnCount(width)

	for _, child in ipairs(p_children) do
		if child:GetUserData("isCharacterCard") == true then
			child:SetRelativeWidth(columnWidth)
		end
	end

	AceGUI:GetLayout("Flow")(p_content, p_children)
end

local function GlobalPlayed_SetFrameResizeBounds(p_frame, p_width, p_height)
	if p_frame.SetResizeBounds ~= nil then
		p_frame:SetResizeBounds(p_width, p_height)
	end
end

-- Here are utils functions needed by the GlobalPlayed_GlobalPlayed_OpenUI function
local function GlobalPlayed_CloseUI(widget)
	isUIShown = false
	GlobalPlayed_SetFrameResizeBounds(widget.frame, ACEGUI_FRAME_MIN_WIDTH, ACEGUI_FRAME_MIN_HEIGHT)
	AceGUI:Release(widget)
end

local function GlobalPlayed_FormatRealmNameLabel(p_label)
	local fontName = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 16)
	p_label.label:SetTextColor(0.17, 0.69, 0.33)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("BOTTOM")
end


local function GlobalPlayed_FormatPlayedLabel(p_label)
	local fontName = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 15)
	p_label.label:SetTextColor(0.9, 0.6, 0.2)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("BOTTOM")
end

local function GlobalPlayed_FormatCharacterLabel(p_label)
	local fontName = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, 12)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV("TOP")
end

local function GlobalPlayed_FillUI(p_UiFrame)
	local scrollFrame = AceGUI:Create("ScrollFrame")
	scrollFrame:SetLayout(CARDS_LAYOUT)
	p_UiFrame:AddChild(scrollFrame)

	local ordered = GlobalPlayed_Account_GetCharactersOrderedByRealm(GlobalPlayed_Characters)

	for k, v in ipairs(ordered) do
		local realmName = AceGUI:Create("Label")
		realmName:SetText(v.name .. string.format(" (%sh)", v.totalAsHours))
		GlobalPlayed_FormatRealmNameLabel(realmName)
		scrollFrame:AddChild(realmName)

		for kk, currCharacter in ipairs(v) do
			local characterName = AceGUI:Create("Label")
			characterName:SetText(GlobalPlayed_Character_GetNameColored(currCharacter))
			GlobalPlayed_FormatCharacterLabel(characterName)

			local charPlayed = AceGUI:Create("Label")
			if GlobalPlayed_Options.useFactionIcon == true then
				charPlayed:SetImage(GlobalPlayed_Character_GetFactionIcon(currCharacter))
				charPlayed:SetImageSize(15, 15)
			end
			charPlayed:SetText(GlobalPlayed_Character_GetPlayedWithTotal(currCharacter))
			GlobalPlayed_FormatPlayedLabel(charPlayed)

			local group = AceGUI:Create("InlineGroup")
			group:SetLayout("List")
			group:SetUserData("isCharacterCard", true)
			group:AddChild(characterName)
			group:AddChild(charPlayed)
			scrollFrame:AddChild(group)
		end
	end
end

-- Global exposed functions to load & open GlobalPlayed UI panel
function GlobalPlayed_LoadUI()
	if GlobalPlayed_Addon_IsLoaded("Ace3") == true then
		AceGUI = LibStub("AceGUI-3.0")
		AceGUI:RegisterLayout(CARDS_LAYOUT, GlobalPlayed_CardsLayout)
		isUIShown = false
	end
end

function GlobalPlayed_OpenUI()
	if isUIShown == false then
		if GlobalPlayed_Options.uiFrameStatus == nil then
			GlobalPlayed_Options.uiFrameStatus = {}
		end

		uiFrame = AceGUI:Create("Frame")
		uiFrame:SetStatusTable(GlobalPlayed_Options.uiFrameStatus)
		GlobalPlayed_SetFrameResizeBounds(uiFrame.frame, FRAME_MIN_WIDTH, FRAME_MIN_HEIGHT)
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