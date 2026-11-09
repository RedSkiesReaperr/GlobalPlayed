**GlobalPlayed Addon** [![curseforge-badge](https://img.shields.io/badge/curseforge-grey?style=for-the-badge&logo=curseforge&logoColor=%23f16436&logoSize=auto&labelColor=%231a1a1a&color=%231a1a1a)](https://www.curseforge.com/wow/addons/globalplayed) [![wagoio-badge](https://img.shields.io/badge/wago.io-blue.svg?logoSize=auto&labelColor=%231a1a1a&color=%231a1a1a&style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA1NDEuNyAzMTEuNiI+PGRlZnM+PHN0eWxlPi5jbHMtMXtmaWxsOiNmZmY7fS5jbHMtMntmaWxsOiNjMTI3MmQ7fTwvc3R5bGU+PC9kZWZzPjxnIGlkPSJMYXllcl8yIiBkYXRhLW5hbWU9IkxheWVyIDIiPjxnIGlkPSJMYXllcl8xLTIiIGRhdGEtbmFtZT0iTGF5ZXIgMSI+PHBhdGggY2xhc3M9ImNscy0xIiBkPSJNMjMwLjgsMTQwLjZoNzkuOGE3Ny4xMSw3Ny4xMSwwLDAsMSw2MC44LTYwLjdWMEExNTYuMTMsMTU2LjEzLDAsMCwwLDIzMC44LDE0MC42WiIvPjxwYXRoIGNsYXNzPSJjbHMtMiIgZD0iTTQ2MS45LDE0MC42aDc5LjhBMTU2LjEzLDE1Ni4xMywwLDAsMCw0MDEuMSwwVjc5LjhBNzcuMSw3Ny4xLDAsMCwxLDQ2MS45LDE0MC42WiIvPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTMxMC43LDE3MC45YzAtLjIuMS0uNC4xLS42aC04MGExLjI3LDEuMjcsMCwwLDAsLjEuNiw3Ny4wNiw3Ny4wNiwwLDAsMS0xNTEuMS0uNkgwYTE1Ni4yNCwxNTYuMjQsMCwwLDAsMjcxLDkwLjMsMTU1LjM4LDE1NS4zOCwwLDAsMCwxMDAuNiw1MC4zVjIzMUE3Ni45Myw3Ni45MywwLDAsMSwzMTAuNywxNzAuOVoiLz48cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik00MDEuMSwyMzEuMVYzMTFBMTU2LjEzLDE1Ni4xMywwLDAsMCw1NDEuNywxNzAuNEg0NjEuOUE3Ny4xMSw3Ny4xMSwwLDAsMSw0MDEuMSwyMzEuMVoiLz48L2c+PC9nPjwvc3ZnPg==)](https://addons.wago.io/addons/globalplayed)
==
Small addon to get your total playtime across characters, on Retail and WoW Forever. Played time is fetched silently at each character login.

**Takes advantage of the LibDataBroker-1.1 library to be ready to use with [**TitanPanel**](https://www.curseforge.com/wow/addons/titan-panel "View it on CurseForge"), [**Arcana** (Formerly ChocolateBar)](https://www.curseforge.com/wow/addons/arcana "View it on CurseForge"), and so many others !**

### **Usage**
* Connect once to each of your characters: WoW only gives the played time of the character you are logged on
* Type any GlobalPlayed command in chat, use the minimap button or the data broker in your display addon
* Retail and WoW Forever keep separate totals

### **Available in-game commands**
* **/gplayed** : Refresh and show the window (or your account total in chat if the window is disabled in options)
* **/gplayed all** : Refresh and show the window (or every character and the account total in chat if the window is disabled in options)
* **/gplayed options** : Open the GlobalPlayed options panel (also via **Esc &gt; Options &gt; Add-ons &gt; GlobalPlayed**)
* A key binding to show or hide played time is available in **Esc &gt; Options &gt; Keybindings &gt; AddOns**

### **Minimap button, addon compartment and data broker**
* **Hover** : characters with their played time, and the account total
* **Left click** : open/close the window, or print the report in chat if the window is disabled
* **Middle click** : refresh the played time
* **Right click** : open the options panel

### **Window**
* Characters grouped by realm, class or faction, sorted by name or played time
* Columns adapt to the window width, and its size and position are remembered
* **Refresh** button next to **Close**

### **Options** (**Esc &gt; Options &gt; Add-ons &gt; GlobalPlayed**)
* Use the window, or print reports in chat
* Class colors, short duration units, full played time with minutes and seconds, faction icons
* Show or hide the minimap button and the addon compartment entry
* Text of the data broker: addon name, account total or current character
* Group and sort characters
* Remove the characters you deleted from the list (the logged in character cannot be removed)
* Import played time from DataStore or Altoholic when they are installed

### **Dependencies**
* [Embedded] [**CallbackHandler-1.0**](https://www.curseforge.com/wow/addons/callbackhandler "View it on CurseForge")
* [Embedded] [**LibDataBroker-1.1**](https://www.curseforge.com/wow/addons/libdatabroker-1-1 "View it on CurseForge")
* [Embedded] [**LibDBIcon-1.0**](https://www.curseforge.com/wow/addons/libdbicon-1-0 "View it on CurseForge")
* [Embedded] [**LibStub**](https://www.curseforge.com/wow/addons/libstub "View it on CurseForge")

### **Translations**
All the texts of GlobalPlayed are listed in `Locales/enUS.lua`, the reference for translators. Pull requests for new languages are welcome! To add one:

1. Copy `Locales/enUS.lua` to a new file named after the game language: `deDE`, `esES`, `esMX`, `itIT`, `koKR`, `ptBR`, `ruRU`, `zhCN` or `zhTW`.
2. Replace the line `GlobalPlayed_Locale_RegisterDefault({` with `GlobalPlayed_Locale_Register("deDE", {`, using your language code.
3. Translate only the right side of each line. The left side must stay in English, exactly as it is. Keep `%s` and `%d` in your text: the addon replaces them with values.
4. In `GlobalPlayed.toc`, add your file right after `Locales/frFR.lua`.
5. Optionally, in `GlobalPlayed.toc`, add the addon list texts: `## Notes-deDE:` and `## Category-deDE:`, using the [official category names](https://warcraft.wiki.gg/wiki/Addon_Categories).
6. Check it on a game client in your language, then open a pull request against `master`.

A translation can be partial: any missing text is displayed in English. When a new text is added to the code, add it to `Locales/enUS.lua` too.

### **Bug reports & Feature requests**
Bug reports and feature requests are welcome. Feel free to create issues on the [GitHub project](https://github.com/RedSkiesReaperr/GlobalPlayed/) to submit them!

## Dev Helps & Docs

- [warcraft.wiki.gg API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API)
- [Lua 5.1 manual](https://www.lua.org/manual/5.1/) (the Lua version used by WoW)
- [wow-ui-source](https://github.com/Gethe/wow-ui-source)

### Releasing
Push a `vX.Y.Z` tag, or `vX.Y.Z-betaN` for a beta. It must match `## Version:` in `GlobalPlayed.toc` and a dated `## X.Y.Z (YYYY-MM-DD)` entry in `CHANGELOG.md`. The workflow then packages the addon and uploads it to CurseForge, Wago and GitHub Releases. Tags must be annotated (`git tag -a`).
