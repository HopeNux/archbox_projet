#!/bin/bash
################################################################################################################
clear
loadkeys fr-pc
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

echo -e "$green ******************************************************************************"
echo -e "$white * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$yellow * Votre console multimédia de salon" 
echo -e "$green * Téléchargement et installation ARCHBOX"
echo -e "$green * Source github :$cyan git clone https://github.com/HopeNux/archbox_projet.git "
echo -e "$white * "
echo -e "$green ******************************************************************************"
echo " "
################################################################################################################


################################################################################################################
echo -e "Installation de GitHub $cyan"
pacman -Sy
pacman -S git --noconfirm
echo -e "$yellow Téléchargement du projet ARCHBOX via GitHub "
git clone https://github.com/HopeNux/archbox_projet.git

echo -e "$red"
read -p "Voulez vous installer ARCHBOX (O/N) : " iarchbox
case $iarchbox in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		iarchbox="ok" ;; 
	*)
		echo " " ;;
esac

if [ "$iarchbox" = "ok" ] ; then
	cd archbox_projet/
	if [ -f "archbox_1config.sh" ] ; then
		sh archbox_1config.sh
	else
		echo -e "Script non présent"
	fi
fi
################################################################################################################

