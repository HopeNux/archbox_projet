﻿#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_3DESKTOP.SH --> DEBUT
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
echo -e "$green * [$red ARCHBOX $green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [DESKTOP XFCE]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo -e "$green * "
#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/3desktop.lck"
if [ -f "$rep/3desktop.lck" ] ; then
	rm $rep/3desktop.lck
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
echo -e "$white * Installation et configuration de XFCE $red"
#----------------------------------------------------------------
# Nouveau utilisateur
#----------------------------------------------------------------
if [ -z "$1" ] ; then
	read -p " * (2) Nouveau utilisateur : (défaut xbmc) " user
	if [ -z "$user" ] ; then
		user="xbmc"
	fi
else
	user="$1"
fi
export HOME="/home/$user"

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
	echo -e "$white * Architecture $2"
fi

#----------------------------------------------------------------
# Installation XFCE
#----------------------------------------------------------------
# A ENLEVER : nepomuk
echo -e "$white * $cyan"
pacman -S --noconfirm xfce4 
pacman -S --noconfirm xfce4-goodies hardinfo gsmartcontrol uget wget
pacman -S --noconfirm gvfs # montage de disque réseau avec thunar.
pacman -S --noconfirm gvfs-smb # gestionnaire de fichier avec prise en charge réseau.
pacman -S --noconfirm gvfs-afc # Montage smartphone
pacman -S --noconfirm gvfs-mtp # Montage tablette ou appareil photo
pacman -S --noconfirm thunar-archive-plugin #  ajoute une entrée dans le menu contextuel (clic droit) pour créer/décompresser les archives depuis Thunar.
pacman -S --noconfirm thunar-volman # pour activer la gestion automatique des disques et médias amovibles.
pacman -S --noconfirm gvfs-gphoto2 gvfs-afp gvfs-goa
pacman -S --noconfirm file-roller lrzip unace unrar p7zip thunar-archive-plugin # Gestionaires d'archives
pacman -S --noconfirm xdg-user-dirs lftp
pacman -S --noconfirm acpi acpid # Gestionnaire d'energie
pacman -S --noconfirm kde-l10n-fr # Avoir les soft kde en fr
pacman -S --noconfirm kdegraphics-kolourpaint # Soft très proche de MSpaint (kde)
pacman -S --noconfirm kaffeine vlc mpv # Lecteurs multimedias
pacman -S --noconfirm gnome-calculator # Calculatrice ( très important :p )
pacman -S --noconfirm mupdf firestarter # Lecteur pdf simple + parfeu
pacman -S --noconfirm faenza-icon-theme # Pack icones faenza / gstreamer0.10-base gstreamer0.10-base-plugins
pacman -S --noconfirm firefox firefox-i18n-fr #Firefox en FR
echo -e "$yellow * [Attention on passe au dessert(yaourt) ahah-ah...!] $cyan"
pacman -Syy
yaourt -S --noconfirm chromium # Chromium libre
yaourt -S --noconfirm chromium-pepper-flash-stable # Chromium libre flash libre
yaourt -S --noconfirm brocade-firmware # Résout l'erreur "WARNING: Possibly missing firmware for module: bfa" ---> AJOUTER COMMENTAIRE EN FIN MODULES="bna" /etc/mkcinit...conf 
# Please add the 'bna' module to $MODULES in /etc/mkinitcpio.conf and rebuild your initcpio to complete the installation
# execut mkinitcpio -p linux
yaourt -S --noconfirm aic94xx-firmware # Résout l'erreur "WARNING: Possibly missing firmware for module: aic94xx"
yaourt -S --noconfirm siano-tv-fw # Résout l'erreur "WARNING: Possibly missing firmware for module: smsmdtv"
yaourt -S --noconfirm xfce-theme-manager ttf-roboto gtk-theme-numix-holo gtk-theme-numix-git numix-icon-theme-git gtk-theme-numix-blue gtk-theme-numix-white gtk-theme-numix-green xcursors-oxygen # themes numix
yaourt -S --noconfirm foxitreader-bin pacmanxg4-bin # lecteur pdf + gestionnaire de paquet
echo -e "$yellow * "
mkdir /link/Jeux
systemctl enable acpid.service
echo -e "$white * Interface sur l'utilisateur $user $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_3DESKTOP.SH --> FIN
#----------------------------------------------------------------
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"			
echo -e "$green * Installation $yellow [DESKTOP]$red Terminé"						   				  
echo -e "$green * "
echo -e "$red * Attention ajouter manuellement 'bna' dans $MODULES sur /etc/mkinitcpio.conf "
echo -e "$red * et recharger mkinitcpio avec ==> mkinitcpio -p linux"
echo -e "$green ****************************************************************************** $nc"
cat <<EOF > $rep/3desktop.lck
#----------------------------------------------------------------
# ARCHBOX_3DESKTOP.SH --> [OK]
#----------------------------------------------------------------
EOF
###############################################################################################

