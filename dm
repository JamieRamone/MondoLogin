#!/bin/sh
####################################################################################################################################
#
#	dm, the Display Manager
#
#	This file is an part of The Mondo Login Application.
#
#	Copyright (C) 2020 Mondo Megagames.
# 	Author: Jamie Ramone <sancombru@gmail.com>
#	Date: 20-4-2020
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see
# <http://www.gnu.org/licenses/>
#
####################################################################################################################################
export XINITRC=/tmp/xinitrc

cat > $XINITRC << 'EOF'
# Set the screen resolution (and the root window's dimensions) to 1920x1080.

xrandr --output $(xrandr | head -n 2 | tail -n 1 | awk '{ print $1 }') --mode 1920x1080

# Set the background color.

xsetroot -solid "#505075" -cursor_name left_ptr

# Start the Login app.

while true; do
	echo "--------------------------------------------------------------------------------------------------------------------------------" >> /var/log/dmd.log 
	/aux/lib/GNUstep/Login.app/Login
done
EOF

chmod 0700 $XINITRC
EXTENSION=$(date -u --iso-8601=minutes)
mv /var/log/dm.log /var/log/dm.log.$EXTENSION
xz -9 /var/log/dm.log.$EXTENSION
xinit -- -quiet -keeptty -novtswitch &>> /var/log/dm.log
