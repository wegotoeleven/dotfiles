#!/usr/bin/env bash

# macos/config.sh

# --------- #
# Functions #
# --------- #

# This function is an if statement that is used with Plistbuddy to check if a key exists in a plist file, and depending on the output, use `set` or add
plistbuddy() {
	local PLIST="${1}"
	local KEY="${2}"
	local TYPE="${3}"
	local VALUE="${4}"
	if /usr/libexec/PlistBuddy -c "Print ${KEY}" "${PLIST}" >/dev/null 2>&1; then
		/usr/libexec/PlistBuddy -c "Set ${KEY} ${VALUE}" "${PLIST}"
	else
		/usr/libexec/PlistBuddy -c "Add ${KEY} ${TYPE} ${VALUE}" "${PLIST}"
	fi
}

# ------ #
# Finder #
# ------ #

plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "DesktopViewSettings:GroupBy" "string" "Kind"
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "DesktopViewSettings:IconViewSettings:iconSize" "integer" 48
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "DesktopViewSettings:IconViewSettings:labelOnBottom" "bool" false
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "DesktopViewSettings:IconViewSettings:showItemInfo" "bool" true
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "DesktopViewSettings:IconViewSettings:textSize" "integer" 11

# FileKit settings (i.e Save dialogs)
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "FK_StandardViewSettings:IconViewSettings:arrangeBy" "string" "Kind"
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "FK_StandardViewSettings:IconViewSettings:iconSize" "integer" 48
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "FK_StandardViewSettings:IconViewSettings:textSize" "integer" 11
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "FK_StandardViewSettings:ExtendedListViewSettingsV2:calculateAllSizes" "bool" true
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "FK_StandardViewSettings:ExtendedListViewSettingsV2:sortColumn" "string" "Kind"
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "FK_StandardViewSettings:ExtendedListViewSettingsV2:textSize" "integer" 11

# Finder view settings
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "StandardViewSettings:IconViewSettings:arrangeBy" "string" "Kind"
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "StandardViewSettings:IconViewSettings:iconSize" "integer" 48
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "StandardViewSettings:IconViewSettings:textSize" "integer" 11
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "StandardViewSettings:ExtendedListViewSettingsV2:calculateAllSizes" "bool" true
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "StandardViewSettings:ExtendedListViewSettingsV2:sortColumn" "string" "Kind"
plistbuddy "${HOME}/Library/Preferences/com.apple.finder.plist" "StandardViewSettings:ExtendedListViewSettingsV2:textSize" "integer" 11

# Show items on the desktop... but then hide it :)
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder CreateDesktop -bool false

# Set the new window target to the home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Spawn Finder in windows instead of tabs
defaults write com.apple.finder FinderSpawnTab -bool false

# Set the search scope to the current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable Finder recent tags
defaults write com.apple.finder ShowRecentTags -bool false

# Set the sort settings to put folders first
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# ---- #
# Dock #
# ---- #

# Set the icon size of Dock items to 48 pixels
defaults write com.apple.dock tilesize -int 48

# Set the Dock to auto-hide
defaults write com.apple.dock autohide -bool true

# Disable recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Wipe all default icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Disable rearrange spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Enable group apps by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true 

# Disable mission control with window drag
defaults write com.apple.dock enterMissionControlByTopWindowDrag -bool false

# --------------- #
# Mission Control #
# --------------- #

# Disable Displays have separate spaces
defaults write com.apple.spaces spans-displays -bool true

# ------ #
# Safari #
# ------ #

# Configure compact tab layout in Safari
defaults write com.apple.Safari ShowStandaloneTabBar -bool false 

# ---- #
# Misc #
# ---- #

# Hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Ensure save dialogues expand by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable iCloud save panel
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Set sidebar item size to small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Set key repeat rate to fast
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Enable ctrl-cmd window dragging
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

# Setup sudo to use Touch ID
sudo tee /etc/pam.d/sudo_local <<EOF
auth       sufficient     pam_tid.so
EOF
sudo chown root:wheel /etc/pam.d/sudo_local
sudo chmod 444 /etc/pam.d/sudo_local

# ---------- #
# Other apps #
# ---------- #

# Shottr
defaults write cc.ffitch.shottr alwaysOnTop -bool true
defaults write cc.ffitch.shottr areaCaptureMode -string "editor"
defaults write cc.ffitch.shottr copyOnEsc -bool false
defaults write cc.ffitch.shottr defaultFolder -string "${HOME}/Desktop"
defaults write cc.ffitch.shottr notificationType -string none
defaults write cc.ffitch.shottr saveOnEsc -bool true

# ------------ #
# Final things #
# ------------ #

# Show the ~/Library folder
chflags nohidden "${HOME}/Library"

# Restart all apps
for app in \
	"cfprefsd" \
	"SystemUIServer" \
	"Dock" \
	"Finder" \
	"Shottr"; do
	killall "${app}" &> /dev/null
done

# Delete all .DS_Store files to reset Finder views to the previously set defaults
find "${HOME}/" -type f -name ".DS_Store" -delete