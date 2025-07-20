#!/usr/bin/env bash
#openwindow>>2d2c87f0,3,clipse,kitty
function handle_open {
  echo ${1:23:6}
  if [[ ${1:0:10} == "openwindow" ]] && [[ ${1:23:6} == "clipse" ]]; then
    echo ${1:12:8} >~/.local/state/clipse/clipse
  fi
}

function handle_close {
  if [[ ${1:0:11} == "closewindow" ]] && [[ ${1:13:8} == $(<~/.local/state/clipse/clipse) ]]; then
    wl-paste | xargs wtype # make it write after focus
  fi
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  handle_open "$line"
  handle_close "$line"
done
