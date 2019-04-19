#!/bin/sh

get_icon() {
  case $1 in
    01d) icon="";; # clear sky day
    01n) icon="";; # clear sky night
    02d) icon="";; # few clouds day
    02n) icon="";; # few clouds night
    03*) icon="";; # scattered clouds
    04*) icon="";; # broken clouds
    09d) icon="";; # shower rain day
    09n) icon="";; # shower rain night
    10d) icon="";; # rain day
    10n) icon="";; # rain night
    11d) icon="";; # thunderstorm day
    11n) icon="";; # thunderstorm night
    13d) icon="";; # snow day
    13n) icon="";; # snow night
    50d) icon="";; # mist day
    50n) icon="";; # mist night
    *) icon="";
  esac

  echo $icon
}

KEY="$OPEN_WEATHER_MAP_API_KEY"
CITY="4393739" # Kirkwood
UNITS="imperial"
SYMBOL="°"

if [ ! -z $CITY ]; then
  weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")
  # weather=$(curl -sf "http://api.openweathermap.org/data/2.5/forecast?APPID=$KEY&id=$CITY&units=$UNITS&cnt=1")
else
  location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

  if [ ! -z "$location" ]; then
    location_lat="$(echo "$location" | jq '.location.lat')"
    location_lon="$(echo "$location" | jq '.location.lng')"

    weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
  fi
fi

if [ ! -z "$weather" ]; then
  weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
  weather_icon=$(echo "$weather" | jq -r ".weather[].icon")
  weather_conditions="$(echo "$weather" | jq -j '.weather[0].main,"\\nHigh: \(.main.temp_max|round)°F","\\nLow: \(.main.temp_min|round)°F","\\nHumidity: \(.main.humidity)%","\\nWind speed: \(.wind.speed) mph","\\nSunrise: \(.sys.sunrise|strflocaltime("%-I:%M %p"))", "\\nSunset: \(.sys.sunset|strflocaltime("%-I:%M %p"))"')"

  echo "{\"text\": \"$(get_icon "$weather_icon") $weather_temp$SYMBOL\", \"tooltip\": \"$weather_conditions\"}"
fi
