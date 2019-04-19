#! /bin/bash

set -e

# peripheral_name="Atreus"
# peripheral_id="feed:6060"
peripheral_name="Terminus"
peripheral_id="1a40:0101"

if lsusb -d "$peripheral_id" ; then
  echo "{\"percentage\": 100, \"tooltip\": \"Peripherals attached\"}"
else
  echo "{\"percentage\": 0}"
fi

udevadm monitor --udev --subsystem-match=usb/usb_device --property |
  awk -v RS= '{
    if (match($0, " (add|bind) .*'"$peripheral_name"'")) {
      print "{\"percentage\": 100, \"tooltip\": \"Peripherals attached\"}";
    } else if (match($0, " (remove|unbind) ") && system("lsusb -d '"$peripheral_id"' > /dev/null")) {
      print "{\"percentage\": 0}";
    }
    fflush();
  }'
