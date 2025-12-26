#!/bin/bash

GMPUBLISH="/mnt/ssda/SteamLibrary/steamapps/common/GarrysMod/bin/gmpublish.exe"
GMPACKER="/mnt/ssda/SteamLibrary/steamapps/common/GarrysMod/bin/gmad.exe"

INPUTIMAGE="./zaza_swep.jpeg"

INPUTFOLDER="./zaza_swep_standalone"
OUTPUTPACK="./zaza_swep_standalone.gma"

$GMPACKER create -folder $INPUTFOLDER -out $OUTPUTPACK
#protontricks-launch $GMPUBLISH create -icon $INPUTIMAGE -addon $OUTPUTPACK
