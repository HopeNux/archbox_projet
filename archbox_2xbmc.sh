#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_2XBMC.SH --> DEBUT
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
echo -e "$green * Installation $yellow [XBMC]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo -e "$white * "
#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/2xbmc.lck"
if [ -f "$rep/2xbmc.lck" ] ; then
	rm $rep/2xbmc.lck
fi

#----------------------------------------------------------------
# Mise à jour + Installation
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
echo -e "$white * "
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ****************************************************************************** $red"
#----------------------------------------------------------------
# Nouveau utilisateur
#----------------------------------------------------------------
if [ -z "$1" ] ; then
	user=$1
else
	read -p " * (2) Nouveau utilisateur : (défaut xbmc) " user
	if [ -z "$user" ] ; then
		user="xbmc"
	fi
fi
export HOME=/home/$user
echo -e "$white * Config /etc/sudoers"
if [[ ! $archi == "rpi" ]];then
	sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
fi

#----------------------------------------------------------------
# Config /home/$user
#----------------------------------------------------------------
echo -e "$white * Config /home/$user/.gtkrc-2.0"
touch $HOME/.gtkrc-2.0
echo 'gtk-icon-theme-name = "gnome"' >> $HOME/.gtkrc-2.0

#----------------------------------------------------------------
# Config /home/$user/.config/user-dirs.dirs
#----------------------------------------------------------------
echo -e "$white * Config /home/$user/.config/user-dirs.dirs"
mkdir $HOME/.config
cat <<EOF >>$HOME/.config/user-dirs.dirs
XDG_DESKTOP_DIR="$HOME/Bureau"
XDG_PUBLICSHARE_DIR="$HOME/Partage"
XDG_DOCUMENTS_DIR="$HOME/Media"
XDG_MUSIC_DIR="$HOME/Musique"
XDG_PICTURES_DIR="$HOME/Image"
EOF

#----------------------------------------------------------------
# Creation repertoire sur /home/$user/
#----------------------------------------------------------------
echo -e "$white * Création repertoire sur $HOME"
mkdir $HOME/Bureau
mkdir $HOME/Musique
mkdir $HOME/Videos
mkdir $HOME/Image
ln -s /link/Partage $HOME/Partage
ln -s /link/Usb $HOME/Usb
ln -s /link/Usb2 $HOME/Usb2
ln -s /media $HOME/Media
echo -e "$white * Création repertoire sur $HOME $yellow [OK]"

#----------------------------------------------------------------
# Config xsession
#----------------------------------------------------------------
echo -e "$white * Config xsession par defaut"
if [ -f "$HOME/.xsession" ] ; then
	rm $HOME/.xsession
fi
cat <<EOF >$HOME/.xsession
#!/bin/sh
# ~/.xsession
# Executed by xdm/gdm/kdm at login
/bin/bash --login -i ~/.xinitrc"
EOF
echo -e "$white * Config .xsession $yellow [OK]$white"

#----------------------------------------------------------------
# Config xinitrc
#----------------------------------------------------------------
echo -e "$white * Config xinitrc par defaut"
if [ -f "$HOME/.xinitrc" ] ; then
	rm $HOME/.xinitrc
fi
cat <<EOF >$HOME/.xinitrc
#!/bin/sh
# ~/.xinitrc
# Executed by startx (run your window manager from here)
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
	    [ -x "$f" ] && . "$f"
	done
	unset f
fi
# exec startxfce4
# exec xbmc
EOF
echo -e "$white * Config .xinitrc $yellow [OK]$white"

#----------------------------------------------------------------
# Config bash_profile
#----------------------------------------------------------------
echo " * Config bash_profile par defaut"
if [ -f "$HOME/.bash_profile" ] ; then
	rm $HOME/.bash_profile
fi
cat <<EOF >$HOME/.bash_profile
# ~/.bash_profile
#
#[[ -f ~/.bashrc ]] && . ~/.bashrc
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
EOF
echo -e "$white * Config .bash_profile $yellow [OK]"
chown $user:users $HOME/*
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Install XBMC"
echo -e "$white ******************************************************************************"
echo -e "$red * Information : XBMC classique ou PVR(tuner tv) ?"
LISTE=(" * Classique" " * PVR")
select CHOIX in "${LISTE[@]}" ; do
case $REPLY in
	1|c)
		echo -e "$white * Installation : XBMC $cyan"
		pacman -Su --noconfirm xbmc 
	break
	;;
	2|p)
		echo -e "$white * Installation :" "$nc" " XBMC PVR $cyan"
		yaourt -S --noconfirm xbmc-eden-pvr-git tvheadend-git linuxtv-dvb-apps w_scan
		systemctl enable tvheadend.service
	break
	;;
	esac
done
echo -e "$white * "
echo -e "$white * Installation XBMC $yellow [OK]"
echo -e "$white * "
echo -e "$white * Controle d'extinction"
echo -e "$white * Ajout du éteindre, restart, veille, pause + télécommande $cyan"
pacman -Su --noconfirm lirc lirc_utils # télécommande
if [ -f "/etc/polkit-1/rules.d/10-xbmc.rules" ] ; then
	rm /etc/polkit-1/rules.d/10-xbmc.rules
fi
cat <<EOF >/etc/polkit-1/rules.d/10-xbmc.rules
polkit.addRule(function(action, subject) {
	if(action.id.match("org.freedesktop.login1.") && subject.isInGroup("power")) {
			return polkit.Result.YES;
	}
});
[Actions for $user user]
Identity=unix-user:$user
EOF

cat <<EOF >/var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
Action=org.freedesktop.devicekit.power.*;org.freedesktop.consolekit.system.*
ResultActive=yes
ResultAny=yes
ResultInactive=no
EOF
echo -e "$white * Controle d'extinction $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_2XBMC.SH --> FIN
#----------------------------------------------------------------
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"			
echo -e "$green * Installation $yellow [XBMC]$red Terminé"						   				  
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################
