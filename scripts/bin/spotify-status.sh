#!/bin/sh

set -e

cleanup() {
  killall playerctl
}
trap cleanup EXIT

main() {
  if [ "$1" = "--json" ]; then
    local format='{"text": "{{ artist }} - {{ title }}", "tooltip": "{{ artist }}\n{{ title }}\n{{ album }}", "class": "{{ lc(status) }}", "percentage": {{ lc(status) }}}'
  else
    local format='{{ artist }} - {{ title }}'
  fi
  playerctl metadata --all-players --format "$format" --follow |
    sed -u 's/"percentage": playing/"percentage": 100/' |
    sed -u 's/"percentage": paused/"percentage": 0/' |
    sed -u 's/&\B/&amp;/g'
}

main "$@" 2> /dev/null
