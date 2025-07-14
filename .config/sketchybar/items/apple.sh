#!/bin/bash

apple_logo=(
  icon=$APPLE
  icon.font="$FONT:Black:16.0"
  icon.color=$GREEN
  padding_right=15
  label.drawing=off
  click_script="open -a 'System Preferences'"
)

sketchybar --add item apple.logo left                  \
           --set apple.logo "${apple_logo[@]}"
