#!/bin/bash

ram_top=(
  label.font="$FONT:Semibold:10"
  icon.drawing=off
  width=0
  padding_right=15
  y_offset=8
  click_script="open -a 'Activity Monitor'"
)

ram_stats=(
  label.font="$FONT:Semibold:12"
  y_offset=-4
  padding_right=15
  width=360
  icon.drawing=off
  script="$PLUGIN_DIR/ram.sh"
  update_freq=10
  updates=on
  click_script="open -a 'Activity Monitor'"
)

sketchybar --add item ram.top right             \
           --set ram.top "${ram_top[@]}"        \
                                                \
           --add item ram.stats right           \
           --set ram.stats "${ram_stats[@]}"    \
           --subscribe ram.stats front_app_switched system_woke
