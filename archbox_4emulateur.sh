#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_4EMULATEUR.SH --> DEBUT
#----------------------------------------------------------------
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
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green * Installation $yellow [EMULATEUR]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
################################################################################################################


################################################################################################################
#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/4emulateur.lck"
if [ -f "$rep/4emulateur.lck" ] ; then
	rm $rep/4emulateur.lck
fi

#----------------------------------------------------------------
# Nouveau utilisateur
#----------------------------------------------------------------
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

echo " "
echo " "

################################################################################################################
#----------------------------------------------------------------
# Installation Emulateur
#----------------------------------------------------------------
echo -e "Installation et configuration de l'emulateur Super Nintendo, Nitendo64, Megadrive ... $cyan"
pacman -S --noconfirm zsnes gens 
mkdir $HOME/.zsnes
cp -R $rep/tools/archbox-emul/zsnes/* $HOME/.zsnes/
echo -e "$white$ok Emulateur Super Nintendo, Nitendo64, Megadrive  $cyan"
echo -e "Installation drivers manettes xbox ... $cyan"
yaourt -S --noconfirm xboxdrv
echo -e "$white$ok Drivers manettes xbox  $cyan"
mkdir /link/Emulateurs
mkdir /link/Jeux
chown -R $user:users $HOME/.zsnes
chown -R $user:users /link/
echo -e "$white$ok Création des dossiers (Emulateurs et Jeux) dans /link  $cyan"
cat <<EOF > $rep/4emulateur.lck
#-------------------------------
# ARCHBOX_4EMULATEUR.SH --> [OK]
#-------------------------------
EOF
################################################################################################################


################################################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"	
echo -e "$green * Installation $yellow [EMULATEUR]$red Terminé"								   				  
echo -e "$green * "
echo -e "$green ****************************************************************************** $nc"
################################################################################################################
