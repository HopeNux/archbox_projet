#!/bin/sh
echo "***************************************************************"
echo "* Installation et configuration de XBMC"
echo "***************************************************************"
export HOME=/home/xbmc
gpasswd -a xbmc users
gpasswd -a touriste xbmc
smbpasswd -a touriste
echo ""

echo "***************************************************************"
echo "* Config /etc/sudoers"
echo "***************************************************************"
# RPI
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo ""

echo "***************************************************************"
echo "* Config /home/xbmc/.bashrc"
echo "***************************************************************"
touch $HOME/.bashrc
echo "" >> $HOME/.bashrc
echo "#Alias xbmc" >> $HOME/.bashrc
echo "alias ll='ls -l'" >> $HOME/.bashrc
echo "alias la='ls -A'" >> $HOME/.bashrc
echo "alias l='ls -CF'" >> $HOME/.bashrc
echo "" >> $HOME/.bashrc
sed -i "s|^PS1='[\u@\h \W]\$ '|PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '|" $HOME/.bashrc
echo "PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '" >> $HOME/.bashrc
chown xbmc:users $HOME/.bashrc
echo ""

echo "***************************************************************"
echo "* Config /home/xbmc/.gtkrc-2.0"
echo "***************************************************************"
touch $HOME/.gtkrc-2.0
echo 'gtk-icon-theme-name = "gnome"' >> $HOME/.gtkrc-2.0
echo ""

echo "***************************************************************"
echo "* Config /home/xbmc/.config/user-dirs.dirs"
echo "***************************************************************"
mkdir $HOME/.config
chown xbmc:users $HOME/.config
touch $HOME/.config/user-dirs.dirs
echo 'XDG_DESKTOP_DIR="'$HOME'/Bureau"' >> $HOME/.config/user-dirs.dirs
echo 'XDG_TEMPLATES_DIR="'$HOME'/Travail"' >> $HOME/.config/user-dirs.dirs
echo 'XDG_PUBLICSHARE_DIR="'$HOME'/Public"' >> $HOME/.config/user-dirs.dirs
echo 'XDG_DOCUMENTS_DIR="'$HOME'/Document"' >> $HOME/.config/user-dirs.dirs
echo 'XDG_MUSIC_DIR="'$HOME'/Musique"' >> $HOME/.config/user-dirs.dirs
echo 'XDG_PICTURES_DIR="'$HOME'/Image"' >> $HOME/.config/user-dirs.dirs

mkdir $HOME/Bureau
mkdir $HOME/Travail
mkdir $HOME/Public
mkdir $HOME/Document
mkdir $HOME/Musique
mkdir $HOME/Image

chown xbmc:users $HOME/Bureau
chown xbmc:users $HOME/Travail
chown xbmc:users $HOME/Public
chown xbmc:users $HOME/Document
chown xbmc:users $HOME/Musique
chown xbmc:users $HOME/Image
chown xbmc:users $HOME/.config/user-dirs.dirs
echo ""

echo "***************************************************************"
echo "* Config xsession"
echo "***************************************************************"
rm $HOME/.xsession
echo "#!/bin/sh" > $HOME/.xsession
echo "# ~/.xsession" >> $HOME/.xsession
echo "# Executed by xdm/gdm/kdm at login" >> $HOME/.xsession
echo "/bin/bash --login -i ~/.xinitrc" >> $HOME/.xsession
echo ""

echo "***************************************************************"
echo "* Config xinitrc"
echo "***************************************************************"
rm $HOME/.xinitrc
echo "#!/bin/sh" > $HOME/.xinitrc
echo "# ~/.xinitrc" >> $HOME/.xinitrc
echo "# Executed by startx (run your window manager from here)" >> $HOME/.xinitrc
echo "if [ -d /etc/X11/xinit/xinitrc.d ]; then" >> $HOME/.xinitrc
echo "  for f in /etc/X11/xinit/xinitrc.d/*; do" >> $HOME/.xinitrc
echo '    [ -x "$f" ] && . "$f"' >> $HOME/.xinitrc
echo "  done" >> $HOME/.xinitrc
echo "  unset f" >> $HOME/.xinitrc
echo "fi" >> $HOME/.xinitrc
echo "# exec startxfce4" >> $HOME/.xinitrc
echo "# exec xbmc" >> $HOME/.xinitrc
echo ""

echo "***************************************************************"
echo "* Config bash_profile"
echo "***************************************************************"
echo "# ~/.bash_profile" > $HOME/.bash_profile
echo "#" >> $HOME/.bash_profile
echo "#[[ -f ~/.bashrc ]] && . ~/.bashrc" >> $HOME/.bash_profile
echo "#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx" >> $HOME/.bash_profile
echo ""

echo "***************************************************************"
echo "* Config Install XBMC"
echo "***************************************************************"
clear
echo -e "$white" "Information :" "$nc" " XBMC classique ou PVR ?"
LISTE=("[c] Classique" "[p] PVR")
select CHOIX in "${LISTE[@]}" ; do
case $REPLY in
	1|c)
		echo -e "$white" "Installation :" "$nc" " XBMC"
		pacman -Su --noconfirm xbmc 
		clear
	break
	;;
	2|p)
		echo -e "$white" "Installation :" "$nc" " XBMC PVR "
		yaourt -S --noconfirm xbmc-eden-pvr-git tvheadend-git linuxtv-dvb-apps w_scan
		systemctl enable tvheadend.service
		clear
	break
	;;
	esac
done
echo ""


echo "***************************************************************"
echo "* Config /lib/systemd/system/xbmc.service"
echo "***************************************************************"
echo "[Unit]" > /usr/lib/systemd/system/xbmc.service
echo "Description=startx automatique pour l'utilisateur xbmc" >> /usr/lib/systemd/system/xbmc.service
echo "After=syslog.target" >> /usr/lib/systemd/system/xbmc.service
echo "" >> /usr/lib/systemd/system/xbmc.service
echo "[Service]" >> /usr/lib/systemd/system/xbmc.service
echo "User=xbmc" >> /usr/lib/systemd/system/xbmc.service
echo "WorkingDirectory=/home/xbmc/" >> /usr/lib/systemd/system/xbmc.service
echo "PAMName=xbmc" >> /usr/lib/systemd/system/xbmc.service
echo "Type=simple" >> /usr/lib/systemd/system/xbmc.service
# Lancement Normal
#echo "ExecStart = /usr/bin/startx /usr/bin/xbmc-standalone -- :0 -nolisten tcp" >> /usr/lib/systemd/system/xbmc.service
# Lancement RPI
echo "ExecStart = /usr/bin/xinit /usr/bin/xbmc-standalone -- :0 -nolisten tcp" >> /usr/lib/systemd/system/xbmc.service
#echo "ExecStart=/bin/bash -l -c startx /usr/bin/xbmc-standalone -- :0" >> /usr/lib/systemd/system/xbmc.service
#echo "ExecStart = /usr/bin/setxkbmap -display :0" >> /usr/lib/systemd/system/xbmc.service
echo "Restart=no" >> /usr/lib/systemd/system/xbmc.service
echo "" >> /usr/lib/systemd/system/xbmc.service
echo "[Install]" >> /usr/lib/systemd/system/xbmc.service
echo "WantedBy=graphical.target" >> /usr/lib/systemd/system/xbmc.service
echo ""

echo "***************************************************************"
echo "* Controle d'extinction"
echo "* Ajout du éteindre, restart, veille, pause" 
echo "***************************************************************"
pacman -Su --noconfirm lirc libxvmc alsa-utils upower polkit udisks
systemctl enable upower
echo 'polkit.addRule(function(action, subject) {' > /etc/polkit-1/rules.d/10-xbmc.rules
echo '	if(action.id.match("org.freedesktop.login1.") && subject.isInGroup("power")) {' >> /etc/polkit-1/rules.d/10-xbmc.rules
echo '		return polkit.Result.YES;' >> /etc/polkit-1/rules.d/10-xbmc.rules
echo '	}' >> /etc/polkit-1/rules.d/10-xbmc.rules
echo '});' >> /etc/polkit-1/rules.d/10-xbmc.rules
echo ""

echo "***************************************************************"
echo "*  Enable SystemD Services"
echo "***************************************************************"
#cp /usr/lib/systemd/system/getty@.service /etc/systemd/system/autologin@.service
#nano /etc/systemd/system/autologin@.service
#systemctl enable autologin@tty1
systemctl disable getty@tty1
cp configuration/autologin@.service /etc/systemd/system/autologin@.service
systemctl daemon-reload
systemctl enable autologin@xbmc.service
#rm /etc/systemd/system/autologin@.service
systemctl enable xbmc.service
echo ""

# echo "***************************************************************"
# echo "* Final Config"
# echo "***************************************************************"
# echo "[Actions for xbmc user]" >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
# echo "Identity=unix-user:xbmc" >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
# echo "Action=org.freedesktop.devicekit.power.*;org.freedesktop.consolekit.system.*" >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
# echo "ResultActive=yes" >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
# echo "ResultAny=yes" >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
# echo "ResultInactive=no" >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.pkla
# echo ""

clear
echo "***************************************************************"
echo "* Arch --> Installation Basic --> Xbmc --> [Drivers]  --> Check "
echo "***************************************************************"
sh archbox_3drivers.sh
