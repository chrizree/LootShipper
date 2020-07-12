# LootShipper

Transfering files from a Raspberry Pi to different kinds of Hak5 devices and further on to an instance of Hak5 Cloud C2

The LootShipper bash script-set is used to get Raspberry Pi loot to Cloud C2 even though there is no client support for the Raspberry Pi (yet as of July 2020).
But, Hak5 devices can be used as a broker to get loot to Cloud C2. This script-set of course needs to be adjusted according to the specific needs for the current scenario at hand.

This script-set is based on the scenario that the Raspberry Pi collects loot and produces a text based loot file. This loot file is transfered to the chosen Hak5 device using scp. The scripts in this script-set are not bullet proof and are for sure in need of certain improval. But, it has been created with the following in mind; "Don't let perfect get in the way of good enough".

NOTE: Do not use this for nefarious reasons, but in agreed red teaming activities or such. Actually, it doesn't need to be linked to any cybersec engagement at all, you can use Cloud C2 and Hak5 devices to monitor outdoor temperature at home getting readings from a Raspberry Pi attached sensor :-)

All trademarks mentioned are the property of their respective owners

Hak5 trademarks in text used solely to refer to and/or link to Hak5’s products and services
