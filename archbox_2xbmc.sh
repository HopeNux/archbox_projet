#!/bin/bash
################################################################################################################
#------------------------------------------------------------------------------------------------------
# ARCHBOX_2XBMC.SH --> DEBUT
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
echo -e "$green * [$red ARCHBOX $green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [XBMC]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
################################################################################################################


################################################################################################################
#------------------------------------------------------------------------------------------------------
# Vérification fichier lck
#------------------------------------------------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/2xbmc.lck"
if [ -f "$rep/2xbmc.lck" ] ; then
	rm $rep/2xbmc.lck
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
echo -e "$green ******************************************************************************"
echo -e "$green * Installation XBMC"
echo -e "$green ******************************************************************************"
echo -e "$red * Information : XBMC classique ou PVR(avec tuner tv) ?"
LISTE=(" * Classique" " * PVR")
select CHOIX in "${LISTE[@]}" ; do
case $REPLY in
	1)
		echo -e "$white$ok Installation XBMC sans PVR $cyan"
		pacman -Su --noconfirm xbmc 
		echo -e "$white$ok Installation XBMC "
	break
	;;
	2)
		echo -e "$white$ok Installation :" "$nc" " XBMC PVR $cyan"
		yaourt -S --noconfirm xbmc-eden-pvr-git tvheadend-git linuxtv-dvb-apps w_scan
		systemctl enable tvheadend.service
		echo -e "$white$ok Installation XBMC "
	break
	;;
	esac
done
################################################################################################################


################################################################################################################
#------------------------------------------------------------------------------------------------------
# RPI
#------------------------------------------------------------------------------------------------------
if [[ ! $archi = "rpi" ]] ; then
	sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
	echo -e "$ok $green Config /etc/sudoers"
fi
#------------------------------------------------------------------------------------------------------
# Creation repertoire sur /home/$user/
#------------------------------------------------------------------------------------------------------
mkdir $HOME/Bureau $HOME/Musique $HOME/Videos $HOME/Image
echo -e "$white$ok Création des repertoires sur $HOME"

#------------------------------------------------------------------------------------------------------
# Gestion irc + télécommande
#------------------------------------------------------------------------------------------------------
pacman -S --noconfirm lirc lirc-utils
if [ -f "/etc/polkit-1/rules.d/10-xbmc.rules" ] ; then
	rm /etc/polkit-1/rules.d/10-xbmc.rules
fi
cat <<EOF >/etc/polkit-1/rules.d/10-xbmc.rules
polkit.addRule(function(action, subject) {
	if(action.id.match("org.freedesktop.login1.") && subject.isInGroup("power")) {
		return polkit.Result.YES;
	}
});
EOF
echo -e "$white$ok Ajout du éteindre, restart, veille, pause + télécommande"

#------------------------------------------------------------------------------------------------------
# Gestion des polices
#------------------------------------------------------------------------------------------------------
cat <<EOF >/var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
[Actions \for $user user]
Identity=unix-user:$user
Action=org.freedesktop.devicekit.power.*;org.freedesktop.consolekit.system.*
ResultActive=yes
ResultAny=yes
ResultInactive=no
EOF
echo -e "$white$ok Controle d\'extinction "


cat <<EOF > $rep/2xbmc.lck
#----------------------------
# ARCHBOX_2XBMC.SH --> [OK]
#----------------------------
EOF
################################################################################################################


################################################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"			
echo -e "$green * Installation $yellow [XBMC]$red Terminé"						   				  
echo -e "$green * "
echo -e "$green ****************************************************************************** $nc"
################################################################################################################
