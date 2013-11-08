#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_3DESKTOP.SH --> DEBUT
#----------------------------------------------------------------
rep=`(cd $(dirname "$0"); pwd)` 2>/dev/null
user="xbmc"

#----------------------------------------------------------------
# Paramètres par défauts
#----------------------------------------------------------------
export LANG=fr_FR.UTF-8
export blue="\\033[1;34m"
export cyan="\\033[1;36m"
export green="\\033[1;32m"
export nc="\\033[0;39m"
export red="\\033[1;31m"
export white="\\033[1;37m"
export yellow="\\033[1;33m"
export HOME=/home/$user

#----------------------------------------------------------------
# Vérification / Creation fichier LOG
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "log" "$rep/archbox_3desktop.log"
echo "" > $rep/archbox_3desktop.log
echo "#----------------------------------------------------------------" >> $rep/archbox_3desktop.log
echo "# ARCHBOX_3DESKTOP.SH --> DEBUT" >> $rep/archbox_3desktop.log
echo "#----------------------------------------------------------------" >> $rep/archbox_3desktop.log
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
###############################################################################################

echo " "
echo " "

###############################################################################################
$rep/tools/archbox-opt/archbox_maj.sh $rep/tools/archbox-opt/archbox_maj.sh
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Installation et configuration de XFCE"
echo -e "$white * $cyan"
pacman -S --noconfirm xfce4 
pacman -S --noconfirm xfce4-goodies gstreamer0.10-base-plugins faenza-icon-theme 
pacman -S --noconfirm p7zip wget unrar xdg-user-dirs lftp thunar thunar-archive-plugin file-roller lrzip unace
pacman -S --noconfirm acpi acpid # gestionnaire d'energie
pacman -S --noconfirm kde-l10n-fr
pacman -Syy
yaourt -S --noconfirm gtk-theme-elementary gtk-theme-numix-git numix-icon-theme-git gtk-theme-numix-blue
echo -e "$white * "
cp -Rv "$rep/tools/archbox-theme/xfce4/" "/home/$user/.config/"
cp -Rv "$rep/tools/archbox-theme/archbox/" "/usr/share/"
cp -v "$rep/tools/archbox-theme/bashrc" "/home/$user/.bashrc"
cp -v "$rep/tools/archbox-theme/gtkrc-2.0" "/home/$user/.gtkrc-2.0"
chown -R $user:users /home/$user
echo -e "$white * Interface sur l'utilisateur $user $yellow [OK]"
echo -e "$white ******************************************************************************"

#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_3desktop.log
echo "#----------------------------------------------------------------" >> $rep/archbox_3desktop.log
echo "# LOG CONFIG XFCE" >> $rep/archbox_3desktop.log
echo "#----------------------------------------------------------------" >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /home/$user/.config/xfce4 " >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /usr/share/archbox " >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /home/$user/.bashrc " >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /home/$user/.gtkrc-2.0 " >> $rep/archbox_3desktop.log
echo "CONFIG XFCE OK " >> $rep/archbox_3desktop.log
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
echo -e "$green ******************************************************************************"
###############################################################################################

