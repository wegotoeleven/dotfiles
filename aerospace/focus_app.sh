#!/usr/bin/env bash
#
# Aerospace Focus App script
# Description: This script is used by Aerospace to focus an app if it's open, or open the app and focus it.
#
# Usage: Setup in Aerospace configuration:
#   shift-ctrl-f = 'exec-and-forget /path/to/focus_app.sh com.apple.finder Finder'
# Author: wegotoeleven

APP_ID=$1
APP_NAME=$2

########################################
# Helper Functions
########################################

focus_app() {
    current_workspace=$(aerospace list-workspaces --focused)
    app_window_id=$(aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name}" | grep "${APP_NAME}" | cut -d' ' -f1 | sed '1p;d')
    aerospace focus --window-id "${app_window_id}"
    # aerospace move-node-to-workspace $current_workspace
    # aerospace workspace $current_workspace
}

app_closed() {
    if aerospace list-windows --all --format '%{app-name}' | grep "${APP_NAME}"; then
        false
    else
        true
    fi
}

########################################
# Main Function
########################################

# Main script execution starts here
main() {
    if app_closed; then
        open -a "${APP_NAME}"
        sleep 0.5
    else
        focus_app
    fi
}

# Execute the main function
main "$@"