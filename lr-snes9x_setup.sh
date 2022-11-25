#!/usr/bin/env bash
#https://github.com/RapidEdwin08/lr-snes9x_1-53
#https://github.com/RetroPie/RetroPie-Setup/blob/master/scriptmodules/libretrocores/lr-snes9x.sh

# ===============================================================
#Reminder: jessie-updates has been removed and jessie-backports has been archived
# sudo nano /etc/apt/sources.list
# deb http://archive.debian.org/debian/ jessie main
# deb-src http://archive.debian.org/debian/ jessie main
# deb http://security.debian.org jessie/updates main
# deb-src http://security.debian.org jessie/updates main
# ===============================================================

snesREF=$(
echo ""
echo "Install [lr-snes9x v1.53] for rPi2/3?"
echo ""
echo "/opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so"
echo "/opt/retropie/configs/snes/emulators.cfg"
echo ""
)

# Confirm installSNESflag
installSNESflag=$(dialog --stdout --no-collapse --title "   *DISCLAIMER* Install at your own Risk   " \
	--ok-label OK --cancel-label Exit \
	--menu "$impLOGO $installSNESflagREF"  25 75 20 \
	1 " [INSTALL]  lr-snes9x v1.53" \
	2 " [REMOVE]  lr-snes9x v1.53" )
	
# installSNESflag Confirmed - Otherwise Exit
if [ "$installSNESflag" == '1' ]; then
	sudo mkdir /opt/retropie/libretrocores/lr-snes9x/ > /dev/null 2>&1
	
	echo "Checking for backup of Default snes9x file"
	if [ -f "/opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so.BAK" ]; then
		echo "snes9x_libretro.so.BAK found . . ."
	else
		echo "Making backup of Default snes9x file"
		sudo mv /opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so /opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so.BAK > /dev/null 2>&1
	fi
	
	echo "Checking for backup of Default docs dir"
	if [ -d "/opt/retropie/libretrocores/lr-snes9x/docs_BAK" ]; then
		echo "docs_BAK found . . ."
	else
		echo "Making backup of Default docs dir"
		sudo mv /opt/retropie/libretrocores/lr-snes9x/docs /opt/retropie/libretrocores/lr-snes9x/docs_BAK > /dev/null 2>&1
	fi
	
	echo "Installing lr-snes9x v1.53"
	cp ~/lr-snes9x_1-53/snes9x_libretro.so /dev/shm/snes9x_libretro.so
	sudo mv /dev/shm/snes9x_libretro.so /opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so
	sudo rm /dev/shm/snes9x_libretro.so > /dev/null 2>&1
	
	echo "Setting the permissions lr-snes9x v1.53"
	sudo chmod 0755 /opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so
	
	sudo mkdir /opt/retropie/libretrocores/lr-snes9x/docs/ > /dev/null 2>&1
	mkdir /dev/shm/docs/ > /dev/null 2>&1
	cp ~/lr-snes9x_1-53/docs/* /dev/shm/docs/ > /dev/null 2>&1
	sudo mv /dev/shm/docs/ /opt/retropie/libretrocores/lr-snes9x/ > /dev/null 2>&1
	sudo rm /dev/shm/docs/ -R -f > /dev/null 2>&1
	
	echo "Adding lr-snex9x to emulators.cfg"
	if [ -f /opt/retropie/configs/snes/emulators.cfg ]; then mkdir /opt/retropie/configs/snes/ > /dev/null 2>&1; touch /opt/retropie/configs/snes/emulators.cfg; fi
	if [ ! $(cat /opt/retropie/configs/snes/emulators.cfg | grep -q 'lr-snes9x =' ; echo $?) == '0' ]; then
		echo 'lr-snes9x = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-snes9x/snes9x_libretro.so --config /opt/retropie/configs/snes/retroarch.cfg %ROM%"' >> /opt/retropie/configs/snes/emulators.cfg
	fi
	
	echo " FINISHIED . . . "
	echo ""
	exit 0
fi

if [ "$installSNESflag" == '2' ]; then
	# REMOVE lr-snes9x
	echo "Removing lr-snes9x"
	sudo rm /opt/retropie/libretrocores/lr-snes9x -R -f > /dev/null 2>&1
	cat /opt/retropie/configs/snes/emulators.cfg | grep -v 'lr-snes9x =' > /dev/shm/emulators.cfg
	mv /dev/shm/emulators.cfg /opt/retropie/configs/snes/emulators.cfg
	
	echo " FINISHIED . . . "
	echo ""
	exit 0
fi

exit 0
