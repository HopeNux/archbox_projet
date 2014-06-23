#!/bin/bash
################################################################################################################
#------------------------------------------------------------------------------------------------------
# ARCHBOX_5DRIVERS.SH --> DEBUT
#------------------------------------------------------------------------------------------------------
archi=`uname -m`
rep=`(cd $(dirname "$0"); pwd)` 2>/dev/null
export LANG="fr_FR.UTF-8"
export keymap="fr-pc"
export blue="\\033[1;34m"
export cyan="\\033[1;36m"
export green="\\033[1;32m"
export nc="\\033[0;39m"
export red="\\033[1;31m"
export white="\\033[1;37m"
export yellow="\\033[1;33m"
export ok="[ $yellow OK $white ]$green"

echo " "
echo " "

echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [DRIVERS]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
################################################################################################################


################################################################################################################
#------------------------------------------------------------------------------------------------------
# Vérification fichier lck
#------------------------------------------------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/5drivers.lck"
if [ -f "$rep/5drivers.lck" ] ; then
	rm $rep/5drivers.lck
fi

#------------------------------------------------------------------------------------------------------
# Nouveau utilisateur
#------------------------------------------------------------------------------------------------------
if [ -z "$1" ] ; then
	read -p "Nouveau utilisateur : (défaut xbmc) " user
	if [ -z "$user" ] ; then
		user="xbmc"
	fi
else
	user="$1"
fi
export HOME="/home/$user"

#------------------------------------------------------------------------------------------------------
# Architecture (i386 - i686 - x86_64 - armv6l)
#------------------------------------------------------------------------------------------------------
echo -e "Votre architecture : $cyan$archi"
echo -e "$red"
if [ "$archi" = "armv6l" ] ; then
	read -p "Votre machine est elle un Raspberry Pi Oui ? Non ? [def:Non] : " rpi
	case $rpi in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
			archi="rpi" ;; 
		*)
			echo "  " ;;
	esac
fi

#------------------------------------------------------------------------------------------------------
# Mise à jour + Installation
#------------------------------------------------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
################################################################################################################


################################################################################################################
echo -e "Installation et configuration de vos drivers ... "
echo -e "Votre carte graphique : $yellow"
lspci | grep -A 2 -i "VGA"
echo -e "$green"

#------------------------------------------------------------------------------------------------------
# Liste des drivers (installation pour le rpi)
#------------------------------------------------------------------------------------------------------
if [ "$archi" == "rpi" ] ; then
	echo -e "Raspberry PI drivers vidéos $cyan"
	pacman -S xf86-video-fbdev
	amixer cset numid=0
else
	echo -e "Choisissez vos drivers ... $red"
	LISTE=(" USB/VM (ati + nouveau + intel + vesa) " " AMD/ATI (affiches commentaires) " " NVIDIA (affiches commentaires)" " INTEL (affiches commentaires)" " MESA (install mesa)" " Deja Installé (ne fait rien) ")
	select CHOIX in "${LISTE[@]}" ; do
	case $REPLY in
			1)
					echo -e "Installation des drivers vidéos par défaut $yellow [USB] $cyan"
					pacman -S xf86-video-intel xf86-video-nouveau nouveau-dri xf86-video-ati xf86-video-vesa
			break
			;;
			2)
					echo -e "Lancement :" "$green" " AMD $cyan"
					echo -e " pacman -S --noconfirm xf86-video-ati$green"
					echo -e "AMD drivers Carte mère$cyan"
					echo -e " pacman -S --noconfirm amd-ucode"
			break
			;;
			3)
					echo -e "Lancement :" "$green" " NVIDIA... $cyan"
					echo -e " pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils$green"
					echo -e " Si conflit libgl avec paquets nvidia utils pacman -Rdd libgl"

					echo -e "Nouveau$cyan"
					echo -e " pacman -S --noconfirm xf86-video-nouveau nouveau-dri$green"
					echo -e " Acceleration 3D : pacman -S --noconfirm libva-vdpau-driver"
					echo -e " Generation du Xorg.conf dans /root/xorg.conf.new : X -configure"
					echo -e " TEST :  X -config /root/xorg.conf.new"
					echo -e " mv /root/xorg.conf.new /etc/X11/xorg.conf"
			break
			;;
			4)
					echo -e "Lancement :" "$green" " INTEL... "
					echo -e "INTEL drivers vidéos$cyan"
					pacman -S --noconfirm xf86-video-intel
			break
			;;
			5)
					echo -e "Lancement :" "$green" " MESA "
					echo -e "ALL drivers vidéos sans acceleration 3D $cyan"
					pacman -S --noconfirm xf86-video-vesa
			break
			;;
			6)
					echo -e "[DEJA INSTALLE] $nc"
			break
			;;
			esac
	done	
fi
echo -e "$ok$white Drivers configurer."

cat <<EOF > $rep/5drivers.lck
#-----------------------------
# ARCHBOX_5DRIVERS.SH --> [OK]
#-----------------------------
EOF
################################################################################################################


################################################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"					
echo -e "$green * Installation $yellow [DRIVERS]$red Terminé"				   				  
echo -e "$green * "
echo -e "$green ******************************************************************************$nc"
################################################################################################################