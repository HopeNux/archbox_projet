#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_5DRIVERS.SH --> DEBUT
#----------------------------------------------------------------
rep=`(cd $(dirname "$0"); pwd)` 2>/dev/null
export LANG=fr_FR.UTF-8
export blue="\\033[1;34m"
export cyan="\\033[1;36m"
export green="\\033[1;32m"
export nc="\\033[0;39m"
export red="\\033[1;31m"
export white="\\033[1;37m"
export yellow="\\033[1;33m"
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
echo -e "$green * "
#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/5drivers.lck"
if [ -f "$rep/5drivers.lck" ] ; then
	rm $rep/5drivers.lck
fi

#----------------------------------------------------------------
# Mise à jour + Installation
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Votre carte graphique :"
lspci | grep -A 2 -i "VGA"
echo -e "$white * Installation et configuration de vos drivers"

#----------------------------------------------------------------
# Architecture (i386 - i686 - x86_64 - armv6l)
#----------------------------------------------------------------
if [ -z "$2" ] ; then
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
else
	echo -e "$white * Tu es un RaspBerryPI"
fi

#----------------------------------------------------------------
# Liste des drivers (installation pour le rpi)
#----------------------------------------------------------------
if [ "$archi" == "rpi" ] ; then
	echo -e "$white * Raspberry PI drivers vidéos "
	echo -e " * $cyan"
	pacman -S xf86-video-fbdev
	amixer cset numid=0
else
	echo -e "$white * Choisissez votre drivers "
	LISTE=(" USB/VM " " AMD/ATI " " NVIDIA " " INTEL " " MESA " " DEJA INSTALLE ")
	select CHOIX in "${LISTE[@]}" ; do
	case $REPLY in
			1|'a')
					echo -e "$white ******************************************************************************"
					echo -e "$white * Installation des drivers vidéos par défaut $yellow [USB] $white"
					echo -e " * $cyan"
					pacman -S xf86-video-intel xf86-video-nouveau nouveau-dri xf86-video-ati xf86-video-vesa
					echo -e "$white ******************************************************************************"
			break
			;;
			2|'z')
					echo -e "$white ******************************************************************************"
					echo -e "$white * AMD drivers vidéos"
					echo -e "$white *  pacman -S --noconfirm xf86-video-ati"
					echo -e "$white * AMD drivers Carte mère"
					echo -e "$white *  pacman -S --noconfirm amd-ucode"
					echo -e "$white ******************************************************************************"
			break
			;;
			3|'e')
					echo -e "$yellow" "Lancement :" "$red" " Emulateurs... $nc"
					echo -e "$white ******************************************************************************"
					echo -e "$white * NVIDIA"
					echo -e "$white *  pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils"
					echo -e "$white *  Si conflit libgl avec paquets nvidia utils pacman -Rdd libgl"
					echo -e "$white ******************************************************************************"
					echo -e "$white * "
					echo -e "$white ******************************************************************************"
					echo -e "$white * Nouveau"
					echo -e "$white *  pacman -S --noconfirm xf86-video-nouveau nouveau-dri"
					echo -e "$white *  Acceleration 3D : pacman -S --noconfirm libva-vdpau-driver"
					echo -e "$white *  Generation du Xorg.conf dans /root/xorg.conf.new : X -configure"
					echo -e "$white *  TEST :  X -config /root/xorg.conf.new"
					echo -e "$white *  mv /root/xorg.conf.new /etc/X11/xorg.conf"
					echo -e "$white ******************************************************************************"
			break
			;;
			4|'r')
					echo -e "$yellow" "Lancement :" "$red" " Emulateurs... $nc"
					echo -e "$white ******************************************************************************"
					echo -e "$white * INTEL"
					echo -e "$white * INTEL drivers vidéos"
					echo -e "$white *  pacman -S --noconfirm xf86-video-intel"
					echo -e "$white ******************************************************************************"
			break
			;;
			5|'t')
					echo -e "$yellow" "[MESA] $nc"
					echo -e "$white ******************************************************************************"
					echo -e "$white * MESA"
					echo -e "$white * ALL drivers vidéos sans acceleration 3D"
					echo -e "$white *  pacman -S --noconfirm xf86-video-vesa"
					echo -e "$white ******************************************************************************"
			break
			;;
			6|'y')
					echo -e "$yellow" "[DEJA INSTALLE] $nc"
			break
			;;
			*|'')
					echo -e "$yellow" "Nothing to do... $nc"
			break
			;;
			esac
	done	
fi
echo -e "$white * Drivers $yellow [OK]"
echo -e "$white ******************************************************************************"
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
echo -e "$green ******************************************************************************$nc"
cat <<EOF > $rep/5drivers.lck
#----------------------------------------------------------------
# ARCHBOX_5DRIVERS.SH --> [OK]
#----------------------------------------------------------------
EOF
###############################################################################################