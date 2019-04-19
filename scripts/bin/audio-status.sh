#! /bin/bash

if pactl list short sinks | grep --quiet "Arctis.*RUNNING" ; then
  echo '{"percentage": 100, "tooltip": "SteelSeries Arctis 7"}'
fi

pactl subscribe | awk '{
    if (match($0, " (on sink) ")) {
      if (system("pactl list short sinks | grep --quiet \"Arctis.*RUNNING\"")) {
        print "{\"percentage\": 0}";
      } else {
        print "{\"percentage\": 100, \"tooltip\": \"SteelSeries Arctis 7\"}";
      }
      fflush();
    }
  }'
