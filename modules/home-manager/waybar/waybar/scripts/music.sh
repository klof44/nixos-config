#!/usr/bin/env bash

while true ; do
  STATUS=$(playerctl --ignore-player firefox status)
  MESSAGE="$(playerctl --ignore-player firefox metadata artist) - $(playerctl --player=%any,firefox metadata title)"

  if [[ $STATUS == Playing ]]; then
    echo '{"text": " '$MESSAGE'", "tooltip": "", "class": "media"}'
  elif [[ $STATUS == Paused ]]; then
	  echo '{"text": " '$MESSAGE'", "tooltip": "", "class": "media"}'
  else
    echo "" 
  fi
  sleep 0.2s
done