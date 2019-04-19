#!/bin/bash

main() {
  is_running="$(systemctl status NetworkManager.service)"
  if [ $? -eq 0 ] ; then
    connection_name="$(nmcli --terse connection show --active | grep ':vpn:' | cut -d : -f 1)"
    [ -n "$connection_name" ] && echo $connection_name
  else
    exit
  fi
}

main "$@" 2>/dev/null
