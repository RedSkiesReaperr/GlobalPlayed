local AceGUI = nil
local uiFrame = nil
local refreshButton = nil
local cardsContainer = nil

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
-- AceGUI places its Close button and status bar at fixed offsets, the Refresh button goes left of Close
local CLOSE_BUTTON_RIGHT = 27
local BOTTOM_BUTTON_WIDTH = 100
local BOTTOM_BUTTON_HEIGHT = 20
local BOTTOM_BUTTONS_Y = 17
local BOTTOM_BUTTONS_GAP = 4
local STATUS_BAR_RIGHT = 132
local STATUS_BAR_Y = 15

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

-- Moves the right edge of the AceGUI status bar, which has no API of its own
local function GlobalPlayed_SetStatusBarRight(p_widget, p_right)
	local statusBar = p_widget.statustext ~= nil and p_widget.statustext:GetParent() or nil

	if statusBar ~= nil then
		statusBar:SetPoint("BOTTOMRIGHT", -p_right, STATUS_BAR_Y)
	end
end

-- Releases the window and its Refresh button, restoring what was changed on the recycled AceGUI frame
local function GlobalPlayed_CloseUI(p_widget)
	if refreshButton ~= nil then
		AceGUI:Release(refreshButton)
	end

	uiFrame = nil
	refreshButton = nil
	cardsContainer = nil
	GlobalPlayed_SetStatusBarRight(p_widget, STATUS_BAR_RIGHT)
	GlobalPlayed_SetFrameResizeBounds(p_widget.frame, ACEGUI_FRAME_MIN_WIDTH, ACEGUI_FRAME_MIN_HEIGHT)
	AceGUI:Release(p_widget)
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

local function GlobalPlayed_FillCards()
	cardsContainer:PauseLayout()
	cardsContainer:ReleaseChildren()

	for k, v in ipairs(GlobalPlayed_Roster_GroupByRealm(GlobalPlayed_Characters)) do
		local realmName = AceGUI:Create("Label")
		realmName:SetText(v.realm .. string.format(" (%sh)", v.totalAsHours))
		GlobalPlayed_StyleLabel(realmName, REALM_FONT_SIZE, "BOTTOM", REALM_COLOR)
		cardsContainer:AddChild(realmName)

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
			cardsContainer:AddChild(group)
		end
	end

	cardsContainer:ResumeLayout()
	cardsContainer:DoLayout()
	uiFrame:SetStatusText(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
end

-- The button stays disabled until the played time reply arrives
local function GlobalPlayed_RefreshUI()
	refreshButton:SetDisabled(true)

	GlobalPlayed_RequestPlayed(function()
		if uiFrame == nil then
			return
		end

		GlobalPlayed_FillCards()
		refreshButton:SetDisabled(false)
	end)
end

-- Global exposed functions to load & open GlobalPlayed UI panel
function GlobalPlayed_LoadUI()
	if GlobalPlayed_Addon_IsLoaded("Ace3") == true then
		AceGUI = LibStub("AceGUI-3.0")
		AceGUI:RegisterLayout(CARDS_LAYOUT, GlobalPlayed_CardsLayout)
	end
end

function GlobalPlayed_OpenUI()
	if uiFrame ~= nil then
		GlobalPlayed_CloseUI(uiFrame)
		return
	end

	if GlobalPlayed_Options.uiFrameStatus == nil then
		GlobalPlayed_Options.uiFrameStatus = {}
	end

	uiFrame = AceGUI:Create("Frame")
	uiFrame:SetStatusTable(GlobalPlayed_Options.uiFrameStatus)
	GlobalPlayed_SetFrameResizeBounds(uiFrame.frame, FRAME_MIN_WIDTH, FRAME_MIN_HEIGHT)
	uiFrame:SetTitle("GlobalPlayed")
	uiFrame:SetLayout("Fill")
	uiFrame:SetCallback("OnClose", function(p_widget) GlobalPlayed_CloseUI(p_widget) end)

	cardsContainer = AceGUI:Create("ScrollFrame")
	cardsContainer:SetLayout(CARDS_LAYOUT)
	uiFrame:AddChild(cardsContainer)

	-- Not part of the content: placed next to the Close button, released with the window
	refreshButton = AceGUI:Create("Button")
	refreshButton:SetText("Refresh")
	refreshButton:SetWidth(BOTTOM_BUTTON_WIDTH)
	refreshButton:SetHeight(BOTTOM_BUTTON_HEIGHT)
	refreshButton:SetCallback("OnClick", GlobalPlayed_RefreshUI)
	refreshButton.frame:SetParent(uiFrame.frame)
	refreshButton.frame:ClearAllPoints()
	refreshButton.frame:SetPoint("BOTTOMRIGHT", uiFrame.frame, "BOTTOMRIGHT", -(CLOSE_BUTTON_RIGHT + BOTTOM_BUTTON_WIDTH + BOTTOM_BUTTONS_GAP), BOTTOM_BUTTONS_Y)
	refreshButton.frame:Show()
	GlobalPlayed_SetStatusBarRight(uiFrame, STATUS_BAR_RIGHT + BOTTOM_BUTTON_WIDTH + BOTTOM_BUTTONS_GAP)

	GlobalPlayed_FillCards()
end
