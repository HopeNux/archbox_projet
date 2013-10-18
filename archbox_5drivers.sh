#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_5DRIVERS.SH --> DEBUT
#----------------------------------------------------------------
rep=`(cd $(dirname "$0"); pwd)`
#----------------------------------------------------------------
# Script des paramètres par défauts
#----------------------------------------------------------------
export LANG=fr_FR.UTF-8
export blue="\\033[1;34m"
export cyan="\\033[1;36m"
export green="\\033[1;32m"
export nc="\\033[0;39m"
export red="\\033[1;31m"
export white="\\033[1;37m"
export yellow="\\033[1;33m"
export HOME=/home/xbmc
#----------------------------------------------------------------
# Vérification / Creation fichier LOG
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "log" "$rep/archbox_5drivers.log"
echo "" > $rep/archbox_5drivers.log
echo "#----------------------------------------------------------------" >> $rep/archbox_5drivers.log
echo "# ARCHBOX_5DRIVERS.SH --> DEBUT" >> $rep/archbox_5drivers.log
echo "#----------------------------------------------------------------" >> $rep/archbox_5drivers.log
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [DRIVERS]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################


echo " "
echo " "


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Mise à jour arch ..."
echo -e " * $cyan"
pacman -Suy --noconfirm
echo -e "$white * Mise à jour$yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Votre carte graphique :"
lspci -k | grep -A 2 -i "VGA"
echo -e "$white * Installation et configuration de vos drivers"
#----------------------------------------------------------------
# Architecture (i386 - i686 - x86_64 - armv6l)
#----------------------------------------------------------------
archi=`uname -m`
echo -e "$green * Votre architecture$yellow $archi"
if [ "$archi" = "armv6l" ] ; then
	echo -e " * $red"
	read -p " * Votre machine est elle un Raspberry Pi Oui ? Non ? [def:Non] : " rpi
	case $rpi in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
			archi="rpi" ;; 
		*)
			echo "$green * " ;;
	esac
fi
if [ "$archi" = "rpi" ] ; then
	echo -e "$white * Raspberry PI drivers vidéos "
	echo -e " * $cyan"
	pacman -S --noconfirm xf86-video-fbdev
else
	echo -e "$white * Installation des drivers vidéos par défaut"
	echo -e " * $cyan"
	pacman -S --noconfirm xf86-video-intel xf86-video-nouveau nouveau-dri xf86-video-ati xf86-video-vesa
	echo " "
	echo " "
	# A FAIRE ATI
	echo -e "$white ******************************************************************************"
	echo -e "$white * AMD drivers vidéos"
	echo -e "$white *  pacman -S --noconfirm xf86-video-ati"
	echo -e "$white * AMD drivers Carte mère"
	echo -e "$white *  pacman -S --noconfirm amd-ucode"
	echo -e "$white ******************************************************************************"
	echo " "
	echo " "
	# A FAIRE NVIDIA
	echo -e "$white ******************************************************************************"
	echo -e "$white * NVIDIA"
	echo -e "$white * touch /etc/X11/xorg.conf.d/10-keyboard-layout.conf"
	echo '*  Section \"InputClass\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf'
	echo '*  	Identifier	\"Keyboard Layout\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf'
	echo '*  	MatchIsKeyboard	\"yes\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf'
	echo '*  	MatchDevicePath	\"/dev/input/event*\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf'
	echo '*  	Option	\"XkbLayout\"	\"fr\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf'
	echo '*  	Option	\"XkbVariant\"	\"latin9\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf'
	echo -e "$white *  EndSection >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf"
	echo -e "$white *  pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils"
	echo -e "$white *  Si conflit libgl avec paquets nvidia utils pacman -Rdd libgl"
	echo -e "$white ******************************************************************************"
	echo " "
	echo " "
	echo -e "$white ******************************************************************************"
	echo -e "$white * Nouveau"
	echo -e "$white *  pacman -S --noconfirm xf86-video-nouveau nouveau-dri"
	echo -e "$white *  Acceleration 3D : pacman -S --noconfirm libva-vdpau-driver"
	echo -e "$white *  Generation du Xorg.conf dans /root/xorg.conf.new : X -configure"
	echo -e "$white *  TEST :  X -config /root/xorg.conf.new"
	echo -e "$white *  mv /root/xorg.conf.new /etc/X11/xorg.conf"
	echo -e "$white ******************************************************************************"
	echo " "
	echo " "
	# A FAIRE INTEL
	echo -e "$white ******************************************************************************"
	echo -e "$white * INTEL"
	echo -e "$white * INTEL drivers vidéos"
	echo -e "$white *  pacman -S --noconfirm xf86-video-intel"
	echo -e "$white ******************************************************************************"
	echo " "
	echo " "
	# A FAIRE MESA
	echo -e "$white ******************************************************************************"
	echo -e "$white * MESA"
	echo -e "$white * ALL drivers vidéos sans acceleration 3D"
	echo -e "$white *  pacman -S --noconfirm xf86-video-vesa"
	echo -e "$white ******************************************************************************"
fi
echo -e "$white * Drivers $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_5drivers.log
echo "#----------------------------------------------------------------" >> $rep/archbox_5drivers.log
echo "# LOG INSTALLATION DRIVERS" >> $rep/archbox_5drivers.log
echo "#----------------------------------------------------------------" >> $rep/archbox_5drivers.log
echo "INSTALLATION DRIVERS OK " >> $rep/archbox_5drivers.log
###############################################################################################


echo " "
echo " "


###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_5DRIVERS.SH --> FIN
#----------------------------------------------------------------
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"					
echo -e "$green * Installation $yellow [DRIVERS]$red Terminé"				   				  
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################