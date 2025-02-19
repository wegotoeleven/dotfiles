#!/usr/bin/env bash

# aerospace/focus_app.sh

APP_ID=$1
APP_NAME=$2

focus_app() {
  current_workspace=$(aerospace list-workspaces --focused)
  app_window_id=$(aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name}" | grep $APP_NAME | cut -d' ' -f1 | sed '1p;d')
  aerospace focus --window-id $app_window_id
  aerospace move-node-to-workspace $current_workspace
  aerospace workspace $current_workspace
}

app_closed() {
  if [ "$(aerospace list-windows --all --format '%{app-name}' | grep $APP_NAME)" == "" ]; then
    true
  else
    false
  fi
}

if app_closed; then
  open -a $APP_NAME
  sleep 0.5
else
  focus_app
fi