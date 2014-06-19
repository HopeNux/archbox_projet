#!/bin/bash
################################################################################################################
#----------------------------------------------------------------
# ARCHBOX_3DESKTOP.SH --> DEBUT
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
echo -e "$green * [$red ARCHBOX $green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [DESKTOP XFCE/LXDE(RPI)]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
################################################################################################################


################################################################################################################
#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/3desktop.lck"
if [ -f "$rep/3desktop.lck" ] ; then
	rm $rep/3desktop.lck
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

#----------------------------------------------------------------
# Mise à jour + Installation
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
################################################################################################################

echo " "
echo " "

################################################################################################################
#----------------------------------------------------------------
# Installation XFCE / LXDE (RPI)
#----------------------------------------------------------------
echo -e "Installation et configuration de XFCE ... $cyan"
pacman -S --noconfirm xfce4 
pacman -S --noconfirm xfce4-goodies hardinfo gsmartcontrol uget pavucontrol xfce-theme-manager
pacman -S --noconfirm faenza-icon-theme # Pack icones faenza / gstreamer0.10-base gstreamer0.10-base-plugins
echo -e "$white$ok Interface XFCE $cyan"

#----------------------------------------------------------------
# Installation des outils de base pour l'interface graphique
#----------------------------------------------------------------
# gvfs 			- Montage de disque réseau avec thunar.
# gvfs-smb		- Gestionnaire de fichier avec prise en charge réseau.
# gvfs-afc		- Montage smartphone
# gvfs-mtp		- Montage tablette ou appareil photo
# archive-plugin- Ajoute une entrée dans le menu contextuel (clic droit) pour créer/décompresser les archives depuis Thunar.
# volman		- Pour activer la gestion automatique des disques et médias amovibles.
pacman -S --noconfirm gvfs gvfs-smb gvfs-afc gvfs-mtp gvfs-gphoto2 gvfs-afp gvfs-goa
pacman -S --noconfirm thunar-archive-plugin thunar-volman
echo -e "$white$ok Thunar et plugins $cyan" 

pacman -S --noconfirm p7zip # Gestionaires d'archives
echo -e "$white$ok Gestionaire d'archive $cyan"

# Avoir les soft kde en fr
# Soft très proche de MSpaint (kde)
# Calculatrice ( très important :p )
# Lecteurs multimedias
pacman -S --noconfirm kde-l10n-fr kdegraphics-kolourpaint kaffeine gnome-calculator vlc mpv mousepad
echo -e "$white$ok Paint - Lecteur video/musique - calculatrice $cyan"

pacman -S --noconfirm firefox firefox-i18n-fr subversion midori
echo -e "$white$ok Navigateur $cyan"

pacman -S --noconfirm firestarter acpi acpid # Gestionnaire d'energie
echo -e "$white$ok Parfeu (firestarter) et Gestionnaire d'energie $cyan"

# D-Bus			- D-bux is a message bus system that provides an easy way for inter-process communication. / D-Bus is enabled automatically when using systemd because dbus is a dependency of systemd.
# Python/2		- Python/2 bindings for the cairo graphics library
pacman -S --noconfirm dbus dbus-python python-cairo python2-cairo 
echo -e "$white$ok Gestionnaire d'energie - dbus - python $yellow"

echo -e "[Attention on passe au dessert(yaourt) ahah-ah...!] $cyan"
yaourt -Syy
yaourt -S --noconfirm foxitreader-bin pacmanxg4-bin # lecteur pdf + gestionnaire de paquet
echo -e "$white$ok foxitreader pacmanxg4(interface de mise a jour) $cyan"
#----------------------------------------------------------------
# Installation des firmware
#----------------------------------------------------------------
# brocade-firmware		- Résout l'erreur "WARNING: Possibly missing firmware for module: bfa" ---> AJOUTER COMMENTAIRE EN FIN MODULES="bna" /etc/mkcinit...conf 
# 						  Please add the 'bna' module to $MODULES in /etc/mkinitcpio.conf and rebuild your initcpio to complete the installation
# 						  execut mkinitcpio -p linux
# aic94xx-firmware		- Résout l'erreur "WARNING: Possibly missing firmware for module: aic94xx
# siano-tv-fw			- Résout l'erreur "WARNING: Possibly missing firmware for module: smsmdtv
yaourt -S --noconfirm brocade-firmware siano-tv-fw aic94xx-firmware
echo -e "$white$ok brocade aic94xx siano-tv (mkinitcpio) $cyan"
#----------------------------------------------------------------
# Installation themes pour XFCE
#----------------------------------------------------------------
yaourt -S --noconfirm numix-icon-theme-git xcursors-oxygen gtk-theme-boje xfce-theme-numix-extra-colors ttf-roboto
echo -e "$green"
mkdir /link/Jeux
#systemctl enable acpid.service
systemctl enable dbus.service

#------------------------------------------------------------------------------------------------------
# Config themes  user .bashrc
#------------------------------------------------------------------------------------------------------
cp $rep/tools/archbox-theme/bashrc /home/$user/.bashrc
cp $rep/tools/archbox-theme/gtkrc-2.0 /home/$user/.gtkrc-2.0
cp -R $rep/tools/archbox-theme/xfce4 /home/$user/.config/
cp -R $rep/tools/archbox-theme/Mousepad /home/$user/.config/
cp -R $rep/tools/archbox-theme/archbox /usr/share/
cp -R $rep/tools/archbox-theme/desktop /home/$user/Desktop
echo -e "$white$ok Interface sur l'utilisateur $user"

chown -R $user:users /home/$user/.bashrc /home/$user/.gtkrc-2.0 /home/$user /home/$user/.config /usr/share/archbox
chmod -R 755 /home/touriste/.bashrc /home/$user/.bashrc /home/$user/.gtkrc-2.0 /home/$user/.config /usr/share/archbox

cat <<EOF > $rep/3desktop.lck
#-----------------------------
# ARCHBOX_3DESKTOP.SH --> [OK]
#-----------------------------
EOF
################################################################################################################

echo " "
echo " "

################################################################################################################
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
################################################################################################################

