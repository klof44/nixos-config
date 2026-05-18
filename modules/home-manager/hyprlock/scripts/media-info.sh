#!/usr/bin/env bash

STATUS=$(playerctl --player=%any --ignore-player=firefox status)
MESSAGE="$(playerctl --player=%any --ignore-player=firefox metadata artist) - $(playerctl --player=%any --ignore-player=firefox metadata title)"

if [[ $STATUS == Playing ]]; then
  echo $MESSAGE
elif [[ $STATUS == Paused ]]; then
  echo $MESSAGE
else
  echo ""
fi