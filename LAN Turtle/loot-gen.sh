#!/bin/bash

# Temporary bash script to generate "fake" loot for testing purposes

# Add as cron job on Raspberry Pi
# 10 * * * * /home/pi/loot-gen.sh >/dev/null 2>&1

DATENOW=$(/bin/date '+%Y-%m-%d %H:%M:%S')

# Set loot directory location
LOOTDIR="/home/pi/loot/"

# Set loot file name
LOOTFILE="lootfile.ascii"

/bin/echo "$DATENOW - Loot file generated, exiting....." >> $LOOTDIR$LOOTFILE
