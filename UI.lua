local AceGUI = nil
local uiFrame = nil

local CARDS_LAYOUT = "GlobalPlayedCards"
local CARD_MIN_WIDTH = 230
local MAX_COLUMNS = 4
local FRAME_MIN_WIDTH = 400
local FRAME_MIN_HEIGHT = 300
-- AceGUI recycles its frames, so the default bounds are restored on close
local ACEGUI_FRAME_MIN_WIDTH = 400
local ACEGUI_FRAME_MIN_HEIGHT = 200

local REALM_COLOR = { 0.17, 0.69, 0.33 }
local PLAYED_COLOR = { 0.9, 0.6, 0.2 }
local REALM_FONT_SIZE = 16
local PLAYED_FONT_SIZE = 15
local CHARACTER_FONT_SIZE = 12
local FACTION_ICON_SIZE = 15

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
	uiFrame = nil
	GlobalPlayed_SetFrameResizeBounds(widget.frame, ACEGUI_FRAME_MIN_WIDTH, ACEGUI_FRAME_MIN_HEIGHT)
	AceGUI:Release(widget)
end

local function GlobalPlayed_StyleLabel(p_label, p_fontSize, p_justifyV, p_color)
	local fontName = p_label.label:GetFont()

	p_label:SetFullWidth(true)
	p_label.label:SetFont(fontName, p_fontSize)
	p_label:SetJustifyH("CENTER")
	p_label:SetJustifyV(p_justifyV)

	if p_color ~= nil then
		p_label.label:SetTextColor(unpack(p_color))
	end
end

local function GlobalPlayed_FillUI(p_UiFrame)
	local scrollFrame = AceGUI:Create("ScrollFrame")
	scrollFrame:SetLayout(CARDS_LAYOUT)
	p_UiFrame:AddChild(scrollFrame)

	local realms = GlobalPlayed_Roster_GroupByRealm(GlobalPlayed_Characters)

	for k, v in ipairs(realms) do
		local realmName = AceGUI:Create("Label")
		realmName:SetText(v.realm .. string.format(" (%sh)", v.totalAsHours))
		GlobalPlayed_StyleLabel(realmName, REALM_FONT_SIZE, "BOTTOM", REALM_COLOR)
		scrollFrame:AddChild(realmName)

		for kk, currCharacter in ipairs(v.characters) do
			local characterName = AceGUI:Create("Label")
			characterName:SetText(GlobalPlayed_Character_GetNameColored(currCharacter))
			GlobalPlayed_StyleLabel(characterName, CHARACTER_FONT_SIZE, "TOP")

			local charPlayed = AceGUI:Create("Label")
			if GlobalPlayed_Options.useFactionIcon == true then
				charPlayed:SetImage(GlobalPlayed_Character_GetFactionIcon(currCharacter))
				charPlayed:SetImageSize(FACTION_ICON_SIZE, FACTION_ICON_SIZE)
			end
			charPlayed:SetText(GlobalPlayed_Character_GetPlayedWithTotal(currCharacter))
			GlobalPlayed_StyleLabel(charPlayed, PLAYED_FONT_SIZE, "BOTTOM", PLAYED_COLOR)

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
	end
end

function GlobalPlayed_OpenUI()
	if uiFrame == nil then
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

		GlobalPlayed_FillUI(uiFrame)
	else
		GlobalPlayed_CloseUI(uiFrame)
	end
end