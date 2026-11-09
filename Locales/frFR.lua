----------------------
-- French translations. See the Translations section of the README to add a language
----------------------
GlobalPlayed_Locale_Register("frFR", {
	-- Durations
	["d"] = "j",
	["h"] = "h",
	["m"] = "m",
	["s"] = "s",
	["days"] = "jours",
	["hours"] = "heures",
	["minutes"] = "minutes",
	["seconds"] = "secondes",

	-- Chat and commands
	["Successfully loaded!"] = "Chargé avec succès !",
	["Account Total: "] = "Total du compte : ",
	["Unknown command: /gplayed "] = "Commande inconnue : /gplayed ",
	["Available commands:"] = "Commandes disponibles :",
	["Show or hide played time"] = "Afficher ou masquer le temps de jeu",

	-- Window
	["Refresh"] = "Actualiser",

	-- Minimap button and data bars
	["Left click"] = "Clic gauche",
	["Show/Hide UI"] = "Afficher ou masquer la fenêtre",
	["Show report in chat"] = "Afficher le rapport dans le chat",
	["Middle click"] = "Clic milieu",
	["Refresh data"] = "Actualiser les données",
	["Right click"] = "Clic droit",
	["Open options panel"] = "Ouvrir les options",
	["Total"] = "Total",
	["Total: %sh"] = "Total : %sh",

	-- Options: general
	["See all your characters played"] = "Le temps de jeu de tous vos personnages",
	["Display"] = "Affichage",
	["Access"] = "Accès",

	-- Options: display
	["Use class colors"] = "Couleurs de classe",
	["Colors character names with their class color in the window, the button tooltip, the chat report and the character list of the options."] = "Colore le nom des personnages selon leur classe dans la fenêtre, l'infobulle du bouton, le rapport du chat et la liste des personnages des options.",
	["Use short duration units"] = "Unités de durée courtes",
	["Display 'd' and 'h' instead of 'days' and 'hours'"] = "Affiche « j » et « h » au lieu de « jours » et « heures »",
	["Show full played time"] = "Temps de jeu complet",
	["Display minutes and seconds in addition to days and hours"] = "Affiche les minutes et les secondes en plus des jours et des heures",
	["Show faction icons"] = "Icônes de faction",
	["Shows the Alliance or Horde icon next to each character in the window and the button tooltip."] = "Affiche l'icône Alliance ou Horde à côté de chaque personnage dans la fenêtre et l'infobulle du bouton.",
	["Group by"] = "Regrouper par",
	["Chooses the sections that gather your characters in the window and the button tooltip."] = "Choisit les sections qui regroupent vos personnages dans la fenêtre et l'infobulle du bouton.",
	["Realm"] = "Royaume",
	["Class"] = "Classe",
	["Faction"] = "Faction",
	["Sort by"] = "Trier par",
	["Order of the characters in the window, the button tooltip and the chat report. Played time puts the most played first."] = "Ordre des personnages dans la fenêtre, l'infobulle du bouton et le rapport du chat. Le temps de jeu place les plus joués en premier.",
	["Name"] = "Nom",
	["Played time"] = "Temps de jeu",

	-- Options: access
	["Use the window"] = "Utiliser la fenêtre",
	["Opens a window listing your characters. When disabled, /gplayed, the key binding and the left click on the button write a report in chat instead."] = "Ouvre une fenêtre qui liste vos personnages. Si désactivé, /gplayed, le raccourci clavier et le clic gauche sur le bouton écrivent un rapport dans le chat.",
	["Show the minimap button"] = "Bouton de la minimap",
	["Shows the GlobalPlayed button on the edge of the minimap."] = "Affiche le bouton GlobalPlayed sur le bord de la minimap.",
	["Show in the minimap addon menu"] = "Menu d'addons de la minimap",
	["Adds GlobalPlayed to the game's addon menu, opened from the small button with a number at the top of the minimap. Useful to hide the round button and keep an access."] = "Ajoute GlobalPlayed au menu d'addons du jeu, ouvert par le petit bouton avec un chiffre en haut de la minimap. Pratique pour masquer le bouton rond tout en gardant un accès.",
	["Broker text"] = "Texte de la barre",
	["Text shown next to the GlobalPlayed icon in data bar addons such as Titan Panel."] = "Texte affiché à côté de l'icône GlobalPlayed dans les addons de barre de données comme Titan Panel.",
	["Addon name"] = "Nom de l'addon",
	["Account total"] = "Total du compte",
	["Current character"] = "Personnage actuel",

	-- Characters page
	["Characters"] = "Personnages",
	["Remove characters you deleted. The logged in character cannot be removed."] = "Retirez les personnages supprimés du jeu. Le personnage connecté ne peut pas être retiré.",
	["Delete"] = "Supprimer",
	["Remove %s from GlobalPlayed?"] = "Retirer %s de GlobalPlayed ?",

	-- DataStore import
	["Import from DataStore"] = "Importer depuis DataStore",
	["Adds the characters known by DataStore or Altoholic that are missing from this list. For the others, keeps the highest played time."] = "Ajoute les personnages connus de DataStore ou Altoholic absents de cette liste. Pour les autres, garde le temps de jeu le plus élevé.",
	["DataStore import: %d added, %d updated"] = "Import DataStore : %d ajoutés, %d mis à jour"
})
