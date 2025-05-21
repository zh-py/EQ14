iwctl adapter phy0 set-property Powered on
iwctl device eth0 set-property Powered on


exec startlxqt &

# (sleep 2 && DISPLAY=:0 systemctl --user start libinput-gestures &) &
# (sleep 2 && systemctl --user start libinput-gestures && systemctl --user start xremap.service &) &
(sleep 2 && systemctl --user start libinput-gestures &) &

wait
