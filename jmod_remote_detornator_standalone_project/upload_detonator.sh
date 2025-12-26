#!/bin/bash

GMPUBLISH="/mnt/ssda/SteamLibrary/steamapps/common/GarrysMod/bin/gmpublish.exe"
GMPACKER="/mnt/ssda/SteamLibrary/steamapps/common/GarrysMod/bin/gmad.exe"

INPUTIMAGE="./detonator_swep.jpg"

INPUTFOLDER="./jmod_remote_detornator"
OUTPUTPACK="./jmod_remote_detornator.gma"

#$GMPACKER create -folder $INPUTFOLDER -out $OUTPUTPACK
protontricks-launch $GMPUBLISH create -icon $INPUTIMAGE -addon $OUTPUTPACK
