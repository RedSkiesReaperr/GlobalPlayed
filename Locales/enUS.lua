----------------------
-- English texts: the reference to translate from, and the fallback of every language
-- The left side is the text used in the code. See the Translations section of the README to add a language
----------------------
GlobalPlayed_Locale_RegisterDefault({
	-- Durations
	["d"] = "d",
	["h"] = "h",
	["m"] = "m",
	["s"] = "s",
	["days"] = "days",
	["hours"] = "hours",
	["minutes"] = "minutes",
	["seconds"] = "seconds",

	-- Chat and commands
	["Successfully loaded!"] = "Successfully loaded!",
	["Account Total: "] = "Account Total: ",
	["Unknown command: /gplayed "] = "Unknown command: /gplayed ",
	["Available commands:"] = "Available commands:",
	["Show or hide played time"] = "Show or hide played time",

	-- Window
	["Refresh"] = "Refresh",

	-- Minimap button and data bars
	["Left click"] = "Left click",
	["Show/Hide UI"] = "Show/Hide UI",
	["Show report in chat"] = "Show report in chat",
	["Middle click"] = "Middle click",
	["Refresh data"] = "Refresh data",
	["Right click"] = "Right click",
	["Open options panel"] = "Open options panel",
	["Total"] = "Total",
	["Total: %sh"] = "Total: %sh",

	-- Options: general
	["See all your characters played"] = "See all your characters played",
	["Display"] = "Display",
	["Access"] = "Access",

	-- Options: display
	["Use class colors"] = "Use class colors",
	["Colors character names with their class color in the window, the button tooltip, the chat report and the character list of the options."] = "Colors character names with their class color in the window, the button tooltip, the chat report and the character list of the options.",
	["Use short duration units"] = "Use short duration units",
	["Display 'd' and 'h' instead of 'days' and 'hours'"] = "Display 'd' and 'h' instead of 'days' and 'hours'",
	["Show full played time"] = "Show full played time",
	["Display minutes and seconds in addition to days and hours"] = "Display minutes and seconds in addition to days and hours",
	["Show faction icons"] = "Show faction icons",
	["Shows the Alliance or Horde icon next to each character in the window and the button tooltip."] = "Shows the Alliance or Horde icon next to each character in the window and the button tooltip.",
	["Group by"] = "Group by",
	["Chooses the sections that gather your characters in the window and the button tooltip."] = "Chooses the sections that gather your characters in the window and the button tooltip.",
	["Realm"] = "Realm",
	["Class"] = "Class",
	["Faction"] = "Faction",
	["Sort by"] = "Sort by",
	["Order of the characters in the window, the button tooltip and the chat report. Played time puts the most played first."] = "Order of the characters in the window, the button tooltip and the chat report. Played time puts the most played first.",
	["Name"] = "Name",
	["Played time"] = "Played time",

	-- Options: access
	["Use the window"] = "Use the window",
	["Opens a window listing your characters. When disabled, /gplayed, the key binding and the left click on the button write a report in chat instead."] = "Opens a window listing your characters. When disabled, /gplayed, the key binding and the left click on the button write a report in chat instead.",
	["Show the minimap button"] = "Show the minimap button",
	["Shows the GlobalPlayed button on the edge of the minimap."] = "Shows the GlobalPlayed button on the edge of the minimap.",
	["Show in the minimap addon menu"] = "Show in the minimap addon menu",
	["Adds GlobalPlayed to the game's addon menu, opened from the small button with a number at the top of the minimap. Useful to hide the round button and keep an access."] = "Adds GlobalPlayed to the game's addon menu, opened from the small button with a number at the top of the minimap. Useful to hide the round button and keep an access.",
	["Broker text"] = "Broker text",
	["Text shown next to the GlobalPlayed icon in data bar addons such as Titan Panel."] = "Text shown next to the GlobalPlayed icon in data bar addons such as Titan Panel.",
	["Addon name"] = "Addon name",
	["Account total"] = "Account total",
	["Current character"] = "Current character",

	-- Characters page
	["Characters"] = "Characters",
	["Remove characters you deleted. The logged in character cannot be removed."] = "Remove characters you deleted. The logged in character cannot be removed.",
	["Delete"] = "Delete",
	["Remove %s from GlobalPlayed?"] = "Remove %s from GlobalPlayed?",

	-- DataStore import
	["Import from DataStore"] = "Import from DataStore",
	["Adds the characters known by DataStore or Altoholic that are missing from this list. For the others, keeps the highest played time."] = "Adds the characters known by DataStore or Altoholic that are missing from this list. For the others, keeps the highest played time.",
	["DataStore import: %d added, %d updated"] = "DataStore import: %d added, %d updated"
})
