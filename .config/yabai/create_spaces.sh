#!/bin/sh

DESIRED_SPACES_PER_DISPLAY=9
CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"

DELTA=0
while read -r line
do
    # Get all spaces for current display
    SPACES=($line)
    EXISTING_SPACE_COUNT=${#SPACES[@]}
    LAST_SPACE=${SPACES[$((EXISTING_SPACE_COUNT-1))]}
    LAST_SPACE=$(($LAST_SPACE+$DELTA))
    
    MISSING_SPACES=$(($DESIRED_SPACES_PER_DISPLAY - $EXISTING_SPACE_COUNT))
    
    if [ "$MISSING_SPACES" -gt 0 ]; then
        # Create missing spaces
        for i in $(seq 1 $MISSING_SPACES)
        do
            NEXT_SPACE=$(($LAST_SPACE+1))
            yabai -m space --create
            LAST_SPACE=$NEXT_SPACE
        done
    elif [ "$MISSING_SPACES" -lt 0 ]; then
        # Remove excess spaces
        for i in $(seq 1 $((-$MISSING_SPACES)))
        do
            yabai -m space --destroy "$LAST_SPACE"
            LAST_SPACE=$(($LAST_SPACE-1))
        done
    fi
    
    DELTA=$(($DELTA+$MISSING_SPACES))
done <<< "$CURRENT_SPACES"

sketchybar --trigger space_change --trigger windows_on_spaces
