# Changelogs

## 1.6.0 (2026-11-07)

- Add WoW Forever support
- Update Interface version for Retail v12.1.5 and Forever v1.60.1
- Add played time is now fetched silently at character login
- Add **/gplayed** and **/gplayed all** now refresh played time before displaying it
- Add MiddleClick on databroker object no longer prints in chat
- Add option to display minutes and seconds in played time
- Add characters can now be removed from the options panel
- Add characters and realms are now sorted by name in every list
- Add GlobalPlayed window now adapts its columns to its width and remembers its size and position
- Add auto build and upload to CurseForge and Wago.io
- Fix account and realm totals losing the minutes of each character
- Fix faction and class are now refreshed at each character login
- Fix databroker clicks ignored on Titan Panel
- Fix options panel checkboxes on current game versions
- Fix install in Interface/AddOns/ without GlobalPlayed/
- Fix addon files loaded twice
- Fix WoW Forever characters now use their full name, so characters sharing a first name are no longer merged
- Fix WoW Forever characters are now grouped under a single header instead of a technical realm name

## 1.5.3 (2025-01-28)

- Update Interface version for v11.0.7
- Update calbackHandler lib 1.0.8 -> 1.0.9
- Fixed removed function IsAddOnLoaded
- Fixed removed function InterfaceOptions_AddCategory
- Fixed removed function InterfaceOptionsFrame_OpenToCategory
- Fixed SetJustifyV() argument

## 1.5.2 (2022-12-03)

- Add Evoker class support

## 1.5.1 (2022-10-29)

- Update Interface version for v10.0
- Fix lua error on closing options panel 

## 1.5.0 (2020-11-28)

- Huge code clean & Optimizations
- Fix addon functions names to be unique and prevent miss override
- Fix addon variables names to be unique and prevent miss override
- Fix all time units now using the same 2digits format
- Fix addon icon can now be displayed in databroker
- Add new options in GlobalPlayed options panel
- Add LeftClick on databroker object will now open/close GlobalPlayed UI (or print report in chat if  Ace3 disabled)
- Add MiddleClick on databroker object will now perform a refresh data refresh
- Add RightClick on databroker object will now open GlobalePlayed options panel
- Add coloration matched with charaters classes (can be enabled/disabled in options panel)
- Add option to switch between short and long time units (can be enabled/disabled in options panel)
- Add you can now vizualize your total playtime for each realms
- Add faction icons displayed next each characters (can be enabled/disabled in options panel)
- Add characters in Ace3 UI are now ordered by realms

## 1.4.2 (2020-11-23)

- Fix GlobalPlayed options panel messages appears anywhere in interface panel

## 1.4.1 (2020-11-02)

- Fix colors for tooltip in in-game addons listing

## 1.4.0 (2020-11-02)

- Add libDataBroker-1.1 integration (To display indos in TitanPanel, etc..)

## 1.3.7 (2020-10-31)

- Fix errors that occurred at startup related to Account & Character classes
- Some code cleaning
- Fix Github action trigger

## 1.3.6 (2020-10-31)

- Add auto packaging with github

## 1.3.5 (2020-10-30)

- Update to interface 90001 to match with WoW v9.0.1

## 1.3.4 (2020-09-09)

- Change addon in-game description to be clearer (suggested by MofSeth on CurseForge)

## 1.3.3 (2020-05-04)

- Fix xml files load errors at startup
- Fix lua errors at startup
- Clean dependencies functions
- Enhance error handling

## 1.3.2 (2020-05-03)

- Add interface options panel
- Add Options SavedVariable
- Add **/gplayed options** in-game command
- Enhance UI error handling

## 1.3.1 (2020-05-02)

- Ace3 is now an optionnal dependency
- Restore **/gplayed all** in-game command 

## 1.3.0 (2020-05-02)

- Add UI 
- Bind UI to **/gplayed** in-game command
- Remove **/gplayed all** in-game command
- Add Ace3 dependency

## 1.2.0 (2020-04-26)

- Add Account class
- Switch to X.X.X semver

## 1.1 (2020-04-26)

- Add **/gplayed all** in-game command
- Add characters realm storage

## 1.0 (2020-04-19)

- Create base
- Add **/gplayed** in-game command