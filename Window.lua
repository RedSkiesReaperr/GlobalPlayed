----------------------
-- Played time window: grouped character cards, built on the game native templates
----------------------
local L = GlobalPlayed_L

local WINDOW_NAME = "GlobalPlayedWindow"
local DEFAULT_WIDTH = 700
local DEFAULT_HEIGHT = 500
local MIN_WIDTH = 400
local MIN_HEIGHT = 300

local CARD_MIN_WIDTH = 230
local CARD_HEIGHT = 56
local CARD_GAP = 6
local HEADER_HEIGHT = 30
local MAX_COLUMNS = 4
local FACTION_ICON_SIZE = 16
local SCROLL_BAR_WIDTH = 18

local BOTTOM_BUTTON_WIDTH = 100
local BOTTOM_BUTTON_HEIGHT = 22
local BOTTOM_BUTTON_RIGHT = 24
local BOTTOM_BUTTON_Y = 3
local BOTTOM_BUTTON_GAP = 4

local REALM_COLOR = { 0.17, 0.69, 0.33 }
local PLAYED_COLOR = { 0.9, 0.6, 0.2 }
local CARD_BACKDROP = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 12,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local window = nil
local cardsContent = nil
local statusText = nil
local refreshButton = nil
local headers = {}
local cards = {}
local groups = {}

-- Returns how many card columns fit in a width, between 1 and MAX_COLUMNS
local function GlobalPlayed_Window_GetColumnCount(p_width)
	return math.max(1, math.min(MAX_COLUMNS, math.floor((p_width + CARD_GAP) / (CARD_MIN_WIDTH + CARD_GAP))))
end

-- Returns the group header at an index, created on first use
local function GlobalPlayed_Window_GetHeader(p_index)
	if headers[p_index] == nil then
		local header = cardsContent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")

		header:SetJustifyH("CENTER")
		header:SetTextColor(unpack(REALM_COLOR))
		headers[p_index] = header
	end

	return headers[p_index]
end

-- Returns the character card at an index, created on first use
local function GlobalPlayed_Window_GetCard(p_index)
	if cards[p_index] == nil then
		local card = CreateFrame("Frame", nil, cardsContent, "BackdropTemplate")

		card:SetBackdrop(CARD_BACKDROP)
		card:SetBackdropColor(0, 0, 0, 0.4)
		card:SetBackdropBorderColor(0.4, 0.4, 0.4)

		card.icon = card:CreateTexture(nil, "ARTWORK")
		card.icon:SetSize(FACTION_ICON_SIZE, FACTION_ICON_SIZE)
		card.icon:SetPoint("LEFT", 8, 0)

		card.nameText = card:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		card.nameText:SetPoint("TOPLEFT", 28, -8)
		card.nameText:SetPoint("TOPRIGHT", -28, -8)
		card.nameText:SetJustifyH("CENTER")
		card.nameText:SetWordWrap(false)

		card.playedText = card:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		card.playedText:SetPoint("TOPLEFT", card.nameText, "BOTTOMLEFT", 0, -4)
		card.playedText:SetPoint("TOPRIGHT", card.nameText, "BOTTOMRIGHT", 0, -4)
		card.playedText:SetJustifyH("CENTER")
		card.playedText:SetTextColor(unpack(PLAYED_COLOR))

		cards[p_index] = card
	end

	return cards[p_index]
end

-- Places the headers and cards for the current width. Called on every resize
local function GlobalPlayed_Window_Layout()
	local width = cardsContent:GetWidth()

	if width == nil or width <= 0 then
		return
	end

	local columns = GlobalPlayed_Window_GetColumnCount(width)
	local cardWidth = (width - ((columns - 1) * CARD_GAP)) / columns
	local y = 0
	local cardIndex = 0

	for groupIndex, group in ipairs(groups) do
		local header = GlobalPlayed_Window_GetHeader(groupIndex)

		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", 0, -y)
		header:SetPoint("TOPRIGHT", 0, -y)
		header:SetHeight(HEADER_HEIGHT)
		y = y + HEADER_HEIGHT

		for characterIndex = 1, #group.characters do
			local column = (characterIndex - 1) % columns
			local row = math.floor((characterIndex - 1) / columns)
			local card = GlobalPlayed_Window_GetCard(cardIndex + characterIndex)

			card:ClearAllPoints()
			card:SetSize(cardWidth, CARD_HEIGHT)
			card:SetPoint("TOPLEFT", column * (cardWidth + CARD_GAP), -(y + (row * (CARD_HEIGHT + CARD_GAP))))
		end

		cardIndex = cardIndex + #group.characters
		y = y + (math.ceil(#group.characters / columns) * (CARD_HEIGHT + CARD_GAP))
	end

	cardsContent:SetHeight(math.max(y, 1))
end

-- Fills the headers, cards and account total from the saved characters
local function GlobalPlayed_Window_Fill()
	groups = GlobalPlayed_Roster_Group(GlobalPlayed_Characters)

	local cardIndex = 0

	for groupIndex, group in ipairs(groups) do
		local header = GlobalPlayed_Window_GetHeader(groupIndex)

		header:SetText(group.label .. GlobalPlayed_PlayedTime_FormatHoursSuffix(group.totalAsHours))
		header:Show()

		for _, character in ipairs(group.characters) do
			cardIndex = cardIndex + 1

			local card = GlobalPlayed_Window_GetCard(cardIndex)

			card.nameText:SetText(GlobalPlayed_Character_GetListName(character))
			card.playedText:SetText(GlobalPlayed_Character_GetPlayedWithTotal(character))

			if GlobalPlayed_Options.useFactionIcon == true then
				card.icon:SetTexture(GlobalPlayed_Character_GetFactionIcon(character))
				card.icon:Show()
			else
				card.icon:Hide()
			end

			card:Show()
		end
	end

	for index = #groups + 1, #headers do
		headers[index]:Hide()
	end

	for index = cardIndex + 1, #cards do
		cards[index]:Hide()
	end

	statusText:SetText(GlobalPlayed_Account_GetPlayed(GlobalPlayed_MyAccount))
	GlobalPlayed_Window_Layout()
end

-- Asks the played time again. The button stays disabled until the reply or the timeout
local function GlobalPlayed_Window_Refresh()
	refreshButton:SetEnabled(false)

	GlobalPlayed_RequestPlayed(function() refreshButton:SetEnabled(true) end)
end

-- Saves the size and position so the window reopens as it was left
local function GlobalPlayed_Window_SaveGeometry()
	local point, _, relativePoint, x, y = window:GetPoint()

	GlobalPlayed_Options.windowStatus = {
		width = window:GetWidth(),
		height = window:GetHeight(),
		point = point,
		relativePoint = relativePoint,
		x = x,
		y = y
	}
end

-- Applies the saved size and position, or centers the window with its default size
local function GlobalPlayed_Window_RestoreGeometry()
	local status = GlobalPlayed_Options.windowStatus

	window:ClearAllPoints()

	if status == nil then
		window:SetSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)
		window:SetPoint("CENTER")
		return
	end

	window:SetSize(status.width, status.height)
	window:SetPoint(status.point, UIParent, status.relativePoint, status.x, status.y)
end

-- Creates the scrollable area holding the cards, using the game minimal scroll bar
local function GlobalPlayed_Window_CreateCardsArea()
	local scrollFrame = CreateFrame("ScrollFrame", nil, window.Inset)
	local scrollBar = CreateFrame("EventFrame", nil, window.Inset, "MinimalScrollBar")

	scrollBar:SetPoint("TOPRIGHT", -6, -6)
	scrollBar:SetPoint("BOTTOMRIGHT", -6, 6)
	scrollBar:SetHideIfUnscrollable(true)

	scrollFrame:SetPoint("TOPLEFT", 8, -6)
	scrollFrame:SetPoint("BOTTOMRIGHT", -SCROLL_BAR_WIDTH - 8, 6)

	cardsContent = CreateFrame("Frame", nil, scrollFrame)
	cardsContent:SetSize(1, 1)
	scrollFrame:SetScrollChild(cardsContent)

	ScrollUtil.InitScrollFrameWithScrollBar(scrollFrame, scrollBar)

	scrollFrame:SetScript("OnSizeChanged", function(_, p_width)
		cardsContent:SetWidth(p_width)
		GlobalPlayed_Window_Layout()
	end)
end

-- Creates the Close and Refresh buttons and the account total line
local function GlobalPlayed_Window_CreateBottomBar()
	local closeButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")

	closeButton:SetSize(BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)
	closeButton:SetPoint("BOTTOMRIGHT", -BOTTOM_BUTTON_RIGHT, BOTTOM_BUTTON_Y)
	closeButton:SetText(CLOSE)
	closeButton:SetScript("OnClick", function() window:Hide() end)

	refreshButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
	refreshButton:SetSize(BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)
	refreshButton:SetPoint("RIGHT", closeButton, "LEFT", -BOTTOM_BUTTON_GAP, 0)
	refreshButton:SetText(L["Refresh"])
	refreshButton:SetScript("OnClick", GlobalPlayed_Window_Refresh)

	statusText = window:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	statusText:SetPoint("LEFT", window, "BOTTOMLEFT", 12, BOTTOM_BUTTON_Y + (BOTTOM_BUTTON_HEIGHT / 2))
	statusText:SetPoint("RIGHT", refreshButton, "LEFT", -8, 0)
	statusText:SetJustifyH("LEFT")
	statusText:SetWordWrap(false)
end

-- Builds the window on first use: movable, resizable and closable with Escape
local function GlobalPlayed_Window_Create()
	window = CreateFrame("Frame", WINDOW_NAME, UIParent, "ButtonFrameTemplate")
	window:Hide()

	ButtonFrameTemplate_HidePortrait(window)
	ButtonFrameTemplate_HideAttic(window)
	window:SetTitle("GlobalPlayed")
	window:SetToplevel(true)
	window:SetClampedToScreen(true)
	window:SetMovable(true)
	window:SetResizable(true)
	window:EnableMouse(true)
	window:RegisterForDrag("LeftButton")
	window:SetScript("OnDragStart", window.StartMoving)
	window:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		GlobalPlayed_Window_SaveGeometry()
	end)

	local resizeButton = CreateFrame("Button", nil, window, "PanelResizeButtonTemplate")

	resizeButton:SetPoint("BOTTOMRIGHT", -4, 4)
	resizeButton:Init(window, MIN_WIDTH, MIN_HEIGHT)
	resizeButton:SetOnResizeStoppedCallback(GlobalPlayed_Window_SaveGeometry)

	GlobalPlayed_Window_CreateCardsArea()
	GlobalPlayed_Window_CreateBottomBar()

	table.insert(UISpecialFrames, WINDOW_NAME)
end

-- Rebuilds the content of the open window, for example after an option change
function GlobalPlayed_Window_Update()
	if window ~= nil and window:IsShown() then
		GlobalPlayed_Window_Fill()
	end
end

-- Opens the window with up to date content, or closes it when already shown
function GlobalPlayed_Window_Toggle()
	if window == nil then
		GlobalPlayed_Window_Create()
	end

	if window:IsShown() then
		window:Hide()
		return
	end

	GlobalPlayed_Window_RestoreGeometry()
	GlobalPlayed_Window_Fill()
	window:Show()
end
