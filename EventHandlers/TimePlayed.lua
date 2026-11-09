local PLAYED_REQUEST_TIMEOUT = 5
local PLAYED_EVENT = "TIME_PLAYED_MSG"

local isRequestPending = false
local requestToken = 0
local pendingCallbacks = {}
local mutedChatFrames = {}

-- Stops chat frames from printing the reply of a request made by the addon
local function GlobalPlayed_MuteChatFrames()
	for i = 1, NUM_CHAT_WINDOWS or 10 do
		local chatFrame = _G["ChatFrame" .. i]

		if chatFrame ~= nil and chatFrame:IsEventRegistered(PLAYED_EVENT) then
			chatFrame:UnregisterEvent(PLAYED_EVENT)
			table.insert(mutedChatFrames, chatFrame)
		end
	end
end

-- Registers the played event back on the chat frames muted by the addon
local function GlobalPlayed_UnmuteChatFrames()
	for _, chatFrame in ipairs(mutedChatFrames) do
		chatFrame:RegisterEvent(PLAYED_EVENT)
	end

	mutedChatFrames = {}
end

-- Ends the pending request: runs its callbacks and unmutes the chat
local function GlobalPlayed_FinishPlayedRequest()
	if isRequestPending == false then
		return
	end

	local callbacks = pendingCallbacks

	isRequestPending = false
	pendingCallbacks = {}

	-- Wait for the next frame so the reply being dispatched cannot reach the chat frames
	C_Timer.After(0, GlobalPlayed_UnmuteChatFrames)

	for _, callback in ipairs(callbacks) do
		callback()
	end
end

-- Silently asks the played time. p_onDone is called on reply, or after a timeout without reply.
function GlobalPlayed_RequestPlayed(p_onDone)
	if p_onDone ~= nil then
		table.insert(pendingCallbacks, p_onDone)
	end

	if isRequestPending == true then
		return
	end

	isRequestPending = true
	requestToken = requestToken + 1

	local token = requestToken

	GlobalPlayed_MuteChatFrames()
	RequestTimePlayed()

	C_Timer.After(PLAYED_REQUEST_TIMEOUT, function()
		if token == requestToken then
			GlobalPlayed_FinishPlayedRequest()
		end
	end)
end

-- Stores a received played time on the current character and the account
function GlobalPlayed_TimePlayedMsgHandler(p_totalSeconds)
	if GlobalPlayed_CurrentCharacter ~= nil then
		GlobalPlayed_Character_UpdatePlayed(GlobalPlayed_CurrentCharacter, p_totalSeconds)

		GlobalPlayed_Account_UpdatePlayed(GlobalPlayed_MyAccount)
		GlobalPlayed_Broker_UpdateText()
		GlobalPlayed_Window_Update()
	end

	GlobalPlayed_FinishPlayedRequest()
end
