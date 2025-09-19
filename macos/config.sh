#!/usr/bin/env bash
#
# macOS Configuration Script
# Description: This script configures macOS system settings, including Finder, Dock, Mission Control, Safari, and other system preferences.
#
# Usage: Run this script to apply changes to system and application settings.
# Author: wegotoeleven

########################################
# Helper Functions
########################################

# Function to configure plist files using PlistBuddy
plistbuddy() {
    local plist="${1}"
    local key="${2}"
    local type="${3}"
    local value="${4}"
    if /usr/libexec/PlistBuddy -c "Print ${key}" "${plist}" >/dev/null 2>&1; then
        /usr/libexec/PlistBuddy -c "Set ${key} ${value}" "${plist}"
    else
        /usr/libexec/PlistBuddy -c "Add ${key} ${type} ${value}" "${plist}"
    fi
}

# Function to configure settings using defaults write (or plistbuddy based on type)
write_setting() {
    local method="${1}"   # 'defaults' or 'plistbuddy'
    local plist="${2}"    # plist file
    local key="${3}"      # key to set
    local type="${4}"     # type of the value
    local value="${5}"    # value to set

    if [[ "$method" == "defaults" ]]; then
        defaults write "$plist" "$key" "$type" "$value"
    elif [[ "$method" == "plistbuddy" ]]; then
        plistbuddy "$plist" "$key" "$type" "$value"
    else
        echo "Invalid method specified."
        exit 1
    fi
}

# Function to restart applications
restart_apps() {
    local apps=(
        "cfprefsd"
        "SystemUIServer"
        "Dock"
        "Finder"
        "Shottr"
    )
    for app in "${apps[@]}"; do
        killall "$app" &>/dev/null
    done
}

########################################
# Finder Configuration
########################################

# Configure Finder settings (using defaults write)
configure_finder() {
    local plist="${HOME}/Library/Preferences/com.apple.finder.plist"
    local settings=(
        "ShowHardDrivesOnDesktop|bool|false"
        "ShowExternalHardDrivesOnDesktop|bool|false"
        "ShowMountedServersOnDesktop|bool|false"
        "ShowRemovableMediaOnDesktop|bool|false"
        "CreateDesktop|bool|false"
        "NewWindowTarget|string|PfHm"
        "FinderSpawnTab|bool|false"
        "FXDefaultSearchScope|string|SCcf"
        "ShowRecentTags|bool|false"
        "_FXSortFoldersFirst|bool|true"
        "_FXSortFoldersFirstOnDesktop|bool|true"
        "FXPreferredViewStyle|string|Nlsv"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "defaults" "$plist" "$key" "-$type" "$value"
    done
}

# Configure Finder settings (using PlistBuddy for specific settings)
configure_finder_plist() {
    local plist="${HOME}/Library/Preferences/com.apple.finder.plist"
    local settings=(
        "DesktopViewSettings:GroupBy|string|Kind"
        "DesktopViewSettings:IconViewSettings:iconSize|integer|48"
        "DesktopViewSettings:IconViewSettings:labelOnBottom|bool|false"
        "DesktopViewSettings:IconViewSettings:showItemInfo|bool|true"
        "DesktopViewSettings:IconViewSettings:textSize|integer|11"
        "FK_StandardViewSettings:IconViewSettings:arrangeBy|string|Kind"
        "FK_StandardViewSettings:IconViewSettings:iconSize|integer|48"
        "FK_StandardViewSettings:IconViewSettings:textSize|integer|11"
        "FK_StandardViewSettings:ExtendedListViewSettingsV2:calculateAllSizes|bool|true"
        "FK_StandardViewSettings:ExtendedListViewSettingsV2:sortColumn|string|Kind"
        "FK_StandardViewSettings:ExtendedListViewSettingsV2:textSize|integer|11"
        "StandardViewSettings:IconViewSettings:arrangeBy|string|Kind"
        "StandardViewSettings:IconViewSettings:iconSize|integer|48"
        "StandardViewSettings:IconViewSettings:textSize|integer|11"
        "StandardViewSettings:ExtendedListViewSettingsV2:calculateAllSizes|bool|true"
        "StandardViewSettings:ExtendedListViewSettingsV2:sortColumn|string|Kind"
        "StandardViewSettings:ExtendedListViewSettingsV2:textSize|integer|11"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "plistbuddy" "$plist" "$key" "$type" "$value"
    done
}

########################################
# Desktop and Dock Configuration
########################################

# Configure Dock settings (using defaults write)
configure_dock() {
    local plist="com.apple.dock"
    local settings=(
        "tilesize|int|48"
        "autohide|bool|true"
        "show-recents|bool|false"
        "static-only|bool|true"
        "mru-spaces|bool|false"
        "expose-group-apps|bool|true"
        "enterMissionControlByTopWindowDrag|bool|false"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "defaults" "$plist" "$key" "-$type" "$value"
    done
}

# Configure Mission Control settings (using defaults write)
configure_mission_control() {
    local plist="com.apple.spaces"
    local settings=(
        "spans-displays|bool|true"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "defaults" "$plist" "$key" "-$type" "$value"
    done
}

# Configure Widget settings (using defaults write)
configure_widgets() {
	local plist="com.apple.chronod"
    local settings=(
        "remoteWidgetsEnabled|bool|false"
		"effectiveRemoteWidgetsEnabled|bool|false"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "defaults" "$plist" "$key" "-$type" "$value"
    done
}

########################################
# Safari Configuration
########################################

# Configure Safari settings (using defaults write)
# Uncomment the lines below to enable Safari Developer menu (optional)
# configure_safari() {
# 	local plist="com.apple.Safari"
#     local settings=(
#         "IncludeDevelopMenu|bool|true"
# 		"WebKitDeveloperExtrasEnabledPreferenceKey|bool|true"
# 		"WebKitPreferences.developerExtrasEnabled|bool|true"
# 		"ShowDevelopMenu|bool|true"
#     )
#     for setting in "${settings[@]}"; do
#         IFS="|" read -r key type value <<< "$setting"
#         write_setting "defaults" "$plist" "$key" "-$type" "$value"
#     done
# }

########################################
# Miscellaneous Configuration
########################################

# Configure miscellaneous system preferences (using defaults write)
configure_globals() {
	local plist="NSGlobalDomain"
    local settings=(
        "_HIHideMenuBar|bool|false"
		"AppleMenuBarVisibleInFullscreen|bool|true"
		"NSNavPanelExpandedStateForSaveMode|bool|true"
		"NSNavPanelExpandedStateForSaveMode2|bool|true"
		"NSDocumentSaveNewDocumentsToCloud|bool|false"
		"NSTableViewDefaultSizeMode|int|1"
		"AppleKeyboardUIMode|int|2"
		"InitialKeyRepeat|int|15"
		"KeyRepeat|int|2"
		"ApplePressAndHoldEnabled|bool|false"
		"NSWindowShouldDragOnGesture|bool|true"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "defaults" "$plist" "$key" "-$type" "$value"
    done
}

########################################
# Shottr Configuration
########################################

# Configure Shottr app settings (using defaults write)
configure_shottr() {
	local plist="cc.ffitch.shottr"
    local settings=(
        "alwaysOnTop|bool|true"
		"areaCaptureMode|string|editor"
		"copyOnEsc|bool|false"
		"defaultFolder|string|${HOME}/Desktop"
		"notificationType|string|none"
		"saveOnEsc|bool|true"
    )
    for setting in "${settings[@]}"; do
        IFS="|" read -r key type value <<< "$setting"
        write_setting "defaults" "$plist" "$key" "-$type" "$value"
    done
}

########################################
# Final Steps
########################################

# Reveal the ~/Library folder in Finder
reveal_library_folder() {
    chflags nohidden "${HOME}/Library"
}

# Delete all .DS_Store files
clear_ds_store() {
    find "${HOME}/" -type f -name ".DS_Store" -delete 2>/dev/null
}

# Setup Touch ID for sudo authentication
setup_touchid_sudo() {
    sudo tee /etc/pam.d/sudo_local <<EOF
auth       sufficient     pam_tid.so
EOF
    sudo chown root:wheel /etc/pam.d/sudo_local
    sudo chmod 444 /etc/pam.d/sudo_local
}

########################################
# Main Function
########################################

# Main script execution starts here
main() {
    # Configure Finder settings
    configure_finder
    configure_finder_plist

    # Configure Desktop and Dock settings
    configure_dock
    configure_mission_control
	configure_widgets

    ## Configure Safari settings (optional)
    # configure_safari

    # Configure global settings
    configure_globals

    # Configure third-party app settings
    configure_shottr

    # Final cleanup and setup
    reveal_library_folder
    clear_ds_store
    setup_touchid_sudo

    # Restart all configured apps
    restart_apps
}

# Execute the main function
main "$@"
