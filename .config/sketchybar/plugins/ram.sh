#!/bin/bash

format_kib() {
  awk -v kib="$1" -v gigabyte_decimals="$2" 'BEGIN {
    if (kib >= 1048576) {
      printf "%.*fGB", gigabyte_decimals, kib / 1048576
    } else if (kib >= 1024) {
      printf "%.0fMB", kib / 1024
    } else {
      printf "%.0fKB", kib
    }
  }'
}

size_to_kib() {
  awk -v size="$1" 'BEGIN {
    unit = substr(size, length(size), 1)
    value = substr(size, 1, length(size) - 1)
    if (unit == "G") {
      print value * 1048576
    } else if (unit == "M") {
      print value * 1024
    } else {
      print value
    }
  }'
}

# Match Activity Monitor's Memory Used: app-backed resident pages, wired memory,
# and compressed memory, excluding reclaimable file-backed cache.
physical_used_kib=$(LC_ALL=C vm_stat | awk '
  /page size of/ {
    for (i = 1; i <= NF; i++) {
      if ($i == "of") page_size = $(i + 1)
    }
  }
  /^Pages active:/ { active = $NF }
  /^Pages inactive:/ { inactive = $NF }
  /^Pages wired down:/ { wired = $NF }
  /^File-backed pages:/ { file_backed = $NF }
  /^Pages stored in compressor:/ { compressed = $NF }
  {
    gsub(/\./, "", active)
    gsub(/\./, "", inactive)
    gsub(/\./, "", wired)
    gsub(/\./, "", file_backed)
    gsub(/\./, "", compressed)
  }
  END {
    print (active + inactive - file_backed + wired + compressed) * page_size / 1024
  }')
physical_total_kib=$(sysctl -n hw.memsize | awk '{ print $1 / 1024 }')
swap_used_kib=$(size_to_kib "$(sysctl vm.swapusage | sed -E 's/.*used = ([0-9.]+)([KMG]).*/\1\2/')")

physical_used=$(format_kib "$physical_used_kib" 2)
physical_total=$(format_kib "$physical_total_kib" 0)
swap_used=$(format_kib "$swap_used_kib" 0)
physical_percent=$(awk -v used="$physical_used_kib" -v total="$physical_total_kib" 'BEGIN {
  printf "%.0f%%", (used / total) * 100
}')

window=$(yabai -m query --windows --window 2>/dev/null)
window_name=$(printf '%s' "$window" | jq -r '.app // empty')
app_pid=$(printf '%s' "$window" | jq -r '.pid // empty')

if [ -n "$window_name" ] && [ -n "$app_pid" ]; then
  app_rss=$(ps -o rss= -p "$app_pid" | tr -d ' ')
  app_memory=$(format_kib "${app_rss:-0}" 2)
  app_percent=$(awk -v rss="${app_rss:-0}" -v total="$physical_total_kib" 'BEGIN {
    printf "%.0f%%", (rss / total) * 100
  }')
else
  window_name=${INFO:-App}
  app_memory="N/A"
  app_percent="N/A"
fi

sketchybar --set ram.top label="$window_name $app_memory ($app_percent)"
sketchybar --set "$NAME" \
  label="$physical_percent | $physical_used / $physical_total | $swap_used Swap"
