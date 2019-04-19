#!/usr/bin/python

# This script requires i3ipc-python package (install it from a system package manager
# or pip).
# It makes inactive windows transparent. Use `transparency_val` variable to control
# transparency strength in range of 0…1.
# Refer: https://github.com/swaywm/sway/blob/master/contrib/inactive-windows-transparency.py

import i3ipc

transparency_val = '0.9';
ipc              = i3ipc.Connection()
prev_focused     = None
prev_workspace   = ipc.get_tree().find_focused().workspace().num

for window in ipc.get_tree():
    if window.focused:
        prev_focused = window
    else:
        window.command('opacity ' + transparency_val)

def on_window_focus(ipc, event):
    global prev_focused
    global prev_workspace

    focused = event.container
    workspace = ipc.get_tree().find_focused().workspace().num

    if focused.id != prev_focused.id: # https://github.com/swaywm/sway/issues/2859
        focused.command('opacity 1')
        if workspace == prev_workspace:
            prev_focused.command('opacity ' + transparency_val)
        prev_focused = focused
        prev_workspace = workspace

ipc.on("window::focus", on_window_focus)
ipc.main()
