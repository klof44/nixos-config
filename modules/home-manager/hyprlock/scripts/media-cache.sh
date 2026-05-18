#!/usr/bin/env bash

URL=$(playerctl metadata --player=%any --ignore-player=firefox | grep artUrl | awk '{print $3}')

if [ -z "$URL" ]; then
    exit 0
fi

if [[ "$URL" == "file://"* ]]; then
  echo ${URL:7}
  exit
fi

CACHE_DIR="/tmp/"
mkdir -p "$CACHE_DIR"
CACHE_FILE="$CACHE_DIR/$(basename "$URL")"

if [ ! -f "$CACHE_FILE" ]; then
    curl -s "$URL" -o "$CACHE_FILE"
fi

#silent
if [[ $1 == "-s" ]]; then
    exit 0
fi

echo $CACHE_FILE