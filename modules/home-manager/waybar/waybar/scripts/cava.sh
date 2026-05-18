#! /usr/bin/env bash

#bar="▔🮂🮃▀🮄🮅🮆█"
bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config
config_file="/tmp/waybar_cava_config"
echo "
[general]
bars = 320
framerate = 120
sensitivity = 200
bar_spacing = 0

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
noise_reduction = 50
reverse = 1
show_idle_bar_heads = 0


" > $config_file

# read stdout from cava
cava -p $config_file | while read -r line; do
    echo $line | sed $dict
done