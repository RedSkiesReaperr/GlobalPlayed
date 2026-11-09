----------------------
-- Translation mechanism: enUS.lua is always loaded, other languages replace its texts
----------------------
-- A text missing from every file still shows its own key instead of breaking the display
GlobalPlayed_L = setmetatable({}, { __index = function(_, p_key) return p_key end })

-- Copies a set of texts into the active translations
local function GlobalPlayed_Locale_Apply(p_translations)
	for key, value in pairs(p_translations) do
		GlobalPlayed_L[key] = value
	end
end

-- Adds the English texts, used for everything a language does not translate
function GlobalPlayed_Locale_RegisterDefault(p_translations)
	GlobalPlayed_Locale_Apply(p_translations)
end

-- Adds the translations of a language, only when the game runs in that language
function GlobalPlayed_Locale_Register(p_locale, p_translations)
	if GetLocale() == p_locale then
		GlobalPlayed_Locale_Apply(p_translations)
	end
end
