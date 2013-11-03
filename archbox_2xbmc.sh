#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_2XBMC.SH --> DEBUT
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
sh $rep/tools/archbox-opt/archbox_error.sh "log" "$rep/archbox_2xbmc.log"
echo "\n#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "# ARCHBOX_2XBMC.SH --> DEBUT" >> $rep/archbox_2xbmc.log
echo "#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
###############################################################################################

echo "\n\n"

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [XBMC]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################


echo "\n\n"


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Mise à jour arch ..."
echo -e " * $cyan"
pacman -Suy --noconfirm
echo -e "$white * Mise à jour$yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################


echo "\n\n"


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Installation et configuration de l'utilisateur XBMC"
echo -e "$white * (3) -> Ajout utilisateur 'xbmc' "
groupadd xbmc
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,xbmc xbmc
echo -e "$white * (3.1) -> Ajout du mot de passe 'xbmc' (pas de connection SSH) : $nc "
passwd xbmc
echo -e "$white * "
gpasswd -a xbmc users
gpasswd -a touriste xbmc
echo -e "$white * Utilisateur xbmc $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "\n#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "# LOG CONFIG UTILISATEUR XBMC" >> $rep/archbox_2xbmc.log
echo "#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "USER XBMC : Group : xbmc + users " >> $rep/archbox_2xbmc.log
echo "USER XBMC : Pas de connection SSH autorisé " >> $rep/archbox_2xbmc.log
echo "CONFIG UTILISATEUR XBMC OK " >> $rep/archbox_2xbmc.log
###############################################################################################


echo "\n\n"


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Config /etc/sudoers"
if [[ ! $archi == "rpi" ]];then
	sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
fi
#----------------------------------------------------------------
# Config /home/xbmc/.bashrc
#----------------------------------------------------------------
cp $rep/tools/archbox-theme/bashrc $HOME/.bashrc
chown xbmc:users $HOME/.bashrc
echo -e "$white * Ajout .bashrc $yellow [OK]"
echo -e "$white * Config /home/xbmc/.gtkrc-2.0"
echo 'gtk-icon-theme-name = "gnome"' >> $HOME/.gtkrc-2.0
#----------------------------------------------------------------
# Config /home/xbmc/.config/user-dirs.dirs
#----------------------------------------------------------------
echo -e "$white * Config /home/xbmc/.config/user-dirs.dirs"
mkdir $HOME/.config
cat > $HOME/.config/user-dirs.dirs << EOF
XDG_DESKTOP_DIR="$HOME/Bureau"
XDG_TEMPLATES_DIR="$HOME/Videos"
XDG_PUBLICSHARE_DIR="$HOME/Partage"
XDG_DOCUMENTS_DIR="$HOME/Media"
XDG_MUSIC_DIR="$HOME/Musique"
XDG_PICTURES_DIR="$HOME/Image"
EOF
#----------------------------------------------------------------
# Creation repertoire sur /home/xbmc/
#----------------------------------------------------------------
echo -e "$white * Création repertoire sur $HOME"
mkdir $HOME/{Bureau,Musique,Videos,Image}
ln -s /link/Partage $HOME/Partage
ln -s /link/Usb $HOME/Usb
ln -s /link/Usb2 $HOME/Usb2
ln -s /media $HOME/Media
chown -R xbmc:users $HOME/
echo "\nexec /usr/bin/archboxboot" >> $HOME/.bash_profile
ll -r $HOME
echo -e "$white * Création repertoire sur $HOME $yellow [OK]"
#----------------------------------------------------------------
# Config xsession
#----------------------------------------------------------------
echo -e "$white * Config xsession"
cat > $HOME/.xsession << EOF
#!/bin/sh
# ~/.xsession
# Executed by xdm/gdm/kdm at login
/bin/bash --login -i ~/.xinitrc
EOF
echo -e "$white * Config xsession $yellow [OK]$white"
#----------------------------------------------------------------
# Config xinitrc
#----------------------------------------------------------------
echo -e "$white * Config xinitrc"
cat > $HOME/.xinitrc << EOF
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
echo -e "$white * Config xinitrc $yellow [OK]$white"
#----------------------------------------------------------------
# Config bash_profile
#----------------------------------------------------------------
echo " * Config bash_profile"
cat > $HOME/.bash_profile << EOF
# ~/.bash_profile
#file
#[[ -f ~/.bashrc ]] && . ~/.bashrc
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
EOF
echo -e "$white * Config bash_profile $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "\n#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "# LOG CONFIG XBMC2" >> $rep/archbox_2xbmc.log
echo "#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "CONFIG XDG voir :  $HOME/.config/user-dirs.dirs" >> $rep/archbox_2xbmc.log
echo "CREATION répertoire voir : $HOME/" >> $rep/archbox_2xbmc.log
echo "CONFIG xsession voir : $HOME/.xsession" >> $rep/archbox_2xbmc.log
echo "CONFIG xinitrc : $HOME/.xinitrc" >> $rep/archbox_2xbmc.log
echo "CONFIG bash_profile voir : $HOME/.bash_profile" >> $rep/archbox_2xbmc.log
echo "XBMC2 [OK]" >> $rep/archbox_2xbmc.log
###############################################################################################


echo "\n\n"


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
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "\n#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "# LOG INSTALLATION XBMC" >> $rep/archbox_2xbmc.log
echo "#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "LOGICIEL XBMC (choix 1=classique 2=tunertv)--> $REPLY [OK]" >> $rep/archbox_2xbmc.log
###############################################################################################


echo "\n\n"

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Controle d'extinction"
echo -e "$white * Ajout du éteindre, restart, veille, pause" 
cat > /etc/polkit-1/rules.d/10-xbmc.rules << EOF
polkit.addRule(function(action, subject) {
	if(action.id.match("org.freedesktop.login1.") && subject.isInGroup("power")) {
		return polkit.Result.YES;
	}
});
EOF
cat > /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla << EOF
[Actions for xbmc user]
Identity=unix-user:xbmc
Action=org.freedesktop.devicekit.power.*;org.freedesktop.consolekit.system.*
ResultActive=yes
ResultAny=yes
ResultInactive=no
EOF
echo -e "$white * Controle d'extinction $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "\n#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "# LOG CONFIG EXTINCTION" >> $rep/archbox_2xbmc.log
echo "#----------------------------------------------------------------" >> $rep/archbox_2xbmc.log
echo "EXTINCTION voir : /etc/polkit-1/rules.d/10-xbmc.rules " >> $rep/archbox_2xbmc.log
echo "EXTINCTION voir : /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla " >> $rep/archbox_2xbmc.log
echo "CONFIG [OK]" >> $rep/archbox_2xbmc.log
###############################################################################################


echo "\n\n"


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
