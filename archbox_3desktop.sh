#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_3DESKTOP.SH --> DEBUT
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
echo -e "$white * Installation et configuration de XFCE"
echo -e "$white * $cyan"
pacman -S --noconfirm xfce4 
pacman -S --noconfirm xfce4-goodies gstreamer0.10-base-plugins faenza-icon-theme
pacman -Syy
yaourt -S --noconfirm gtk-theme-elementary
echo -e "$white * "
cp -Rv "$rep/tools/archbox-theme/xfce4/" "/home/xbmc/.config/"
cp -Rv "$rep/tools/archbox-theme/archbox/" "/usr/share/"
cp -v "$rep/tools/archbox-theme/bashrc" "/home/xbmc/.bashrc"
cp -v "$rep/tools/archbox-theme/gtkrc-2.0" "/home/xbmc/.gtkrc-2.0"
chown -Rv xbmc:users /home/xbmc
echo -e "$white * Utilisateur xbmc $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_3desktop.log
echo "#----------------------------------------------------------------" >> $rep/archbox_3desktop.log
echo "# LOG CONFIG XFCE" >> $rep/archbox_3desktop.log
echo "#----------------------------------------------------------------" >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /home/xbmc/.config/xfce4 " >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /usr/share/archbox " >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /home/xbmc/.bashrc " >> $rep/archbox_3desktop.log
echo "CONFIG Theme : /home/xbmc/.gtkrc-2.0 " >> $rep/archbox_3desktop.log
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

