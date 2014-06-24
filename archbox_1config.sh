#!/bin/bash
################################################################################################################
#------------------------------------------------------------------------------------------------------
# ARCHBOX_1CONFIG.SH 
#------------------------------------------------------------------------------------------------------
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

echo " "
echo " "

echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
echo " "
echo -e "$green ******************************************************************************"
echo -e "$green * Définition du répertoire source $rep "
echo -e "$green * Configuration de la langue $LANG"
echo -e "$green * Architecture detecte $archi"
echo -e "$green * Installation des elements principaux d'archlinux (sans aucune interface)"
echo -e "$yellow * Si vous avez deja lancer se script activer le mod debug !"
echo -e "$green ******************************************************************************"
echo " "
read -p "Appuyer sur une touche pour continuer ..."


################################################################################################################
#------------------------------------------------------------------------------------------------------
# Check lock file
#------------------------------------------------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/1config.lck"
if [ -f "$rep/1config.lck" ] ; then
	rm $rep/1config.lck
fi

#------------------------------------------------------------------------------------------------------
# Config /etc/localtime
#------------------------------------------------------------------------------------------------------
rm /etc/localtime 2>/dev/null
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo -e "$white$ok /etc/localtime "

echo "LANG=$LANG" > /etc/locale.conf
echo "LC_COLLATE=C" > /etc/locale.conf
echo -e "$white$ok /etc/locale.conf"

echo "Europe/Paris" > /etc/timezone
echo -e "$white$ok /etc/timezone "

cat <<EOF >/etc/rc.conf
LOCALE="$LANG"
TIMEZONE="Europe/Paris"
KEYMAP="fr"
USECOLOR="yes"
@network
EOF
echo -e "$white$ok /etc/rc.conf"

sed -i 's/^#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#fr_FR ISO-8859-1/fr_FR ISO-8859-1/' /etc/locale.gen
sed -i 's/^#fr_FR@euro ISO-8859-15/fr_FR@euro ISO-8859-15/' /etc/locale.gen
locale-gen
echo -e "$white$ok /etc/locale.gen"

#------------------------------------------------------------------------------------------------------
# Update & Install
#------------------------------------------------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
echo -e "Installation : net-tools samba smbclient ... $cyan"
pacman -S --noconfirm net-tools samba smbclient smbnetfs
echo -e "$white$ok Installation : net-tools samba smbclient"
cp $rep/tools/archbox-network/smb.conf /etc/samba/
echo -e "$white$ok Copie samba config"
################################################################################################################

echo " "
echo " "
echo " "
echo " "

################################################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green *$red Saisie de l'utilisateur ..."
echo -e "$green * "
echo -e "$green ******************************************************************************"
################################################################################################################

echo -e "$red"

################################################################################################################
#------------------------------------------------------------------------------------------------------
# Name of the computer (which show on the network)
#------------------------------------------------------------------------------------------------------
read -p "Nom de votre machine (defaut ARCHBOX) : " nomdupc
if [ -z "$nomdupc" ] ; then
    echo "ARCHBOX" > /etc/hostname
	nomdupc="ARCHBOX"
else
	echo $nomdupc > /etc/hostname
fi

#------------------------------------------------------------------------------------------------------
# Architecture (i386 - i686 - x86_64 - armv6l)
#------------------------------------------------------------------------------------------------------
echo -e "$green Votre architecture : $cyan$archi"
if [ "$archi" = "armv6l" ] ; then
	echo -e "$red"
	read -p "Votre machine est elle un Raspberry Pi Oui ? Non ? [def:Non] : " rpi
	case $rpi in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
			archi="rpi" ;; 
		*)
			echo "  " ;;
	esac
fi

#------------------------------------------------------------------------------------------------------
# Config /etc/vconsole.conf
#------------------------------------------------------------------------------------------------------
if [ "$archi" = "rpi" ] ; then
	echo "KEYMAP=$keymap" >> /etc/vconsole.conf # Attention si le script passe une deuxieme fois
else
	echo "KEYMAP=$keymap" > /etc/vconsole.conf
fi
echo "FONT=" >> /etc/vconsole.conf
echo "FONT_MAP=" >> /etc/vconsole.conf
echo -e "$white$ok Mise à jour keymap:$keymap dans /etc/vconsole.conf $green"

#------------------------------------------------------------------------------------------------------
# Config user touriste
#------------------------------------------------------------------------------------------------------
echo -e "Installation et configuration de l'utilisateur 'touriste' avec partage réseau ...$red "
groupadd touriste
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power -s /bin/bash touriste
echo -e "Mot de passe$green 'touriste' pour connection SSH only : $red"
passwd touriste
echo -e "Mot de passe$green 'touriste' pour SAMBA (partage réseau) :$red"
smbpasswd -a touriste
gpasswd -a touriste users
echo -e "$white$ok Utilisateur touriste configuré $green"

#------------------------------------------------------------------------------------------------------
# Config new user (defaut xbmc)
#------------------------------------------------------------------------------------------------------
echo -e "Installation et configuration du nouvel utilisateur (sans partage) ...$red"
read -p "Entrez le nom du nouvel utilisateur (défaut xbmc) : " user
if [ -z "$user" ] ; then
	user="xbmc"
fi
export HOME="/home/$user"
groupadd xbmc
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,xbmc $user
echo -e "Mot de passe$green '$user' (pas de connection SSH) : $red"
passwd $user
gpasswd -a touriste xbmc
gpasswd -a $user users
echo -e "$white$ok Utilisateur $user configuré $green"

#------------------------------------------------------------------------------------------------------
# Config root
#------------------------------------------------------------------------------------------------------

echo -e "Installation et configuration de l'utilisateur 'root' ... $red" 
echo -e "Mot de passe$green 'root' (pas de connection SSH) : $red"
passwd root
echo -e "$white$ok Utilisateur root configuré"

#------------------------------------------------------------------------------------------------------
# Config themes root / touriste / user .bashrc
#------------------------------------------------------------------------------------------------------
rm /home/touriste/.bashrc 2>/dev/null
rm /home/$user/.bashrc 2>/dev/null

cp $rep/tools/archbox-theme/bashrc /root/.bashrc
cp $rep/tools/archbox-theme/bashrc /home/touriste/.bashrc
cp $rep/tools/archbox-theme/bashrc /home/$user/.bashrc

cp $rep/tools/archbox-theme/gtkrc-2.0 /home/$user/.gtkrc-2.0
cp -R $rep/tools/archbox-theme/xfce4 /home/$user/.config/
cp -R $rep/tools/archbox-theme/archbox /usr/share/

chown touriste:users /home/touriste/.bashrc
chown -R $user:users /home/$user/.bashrc /home/$user/.gtkrc-2.0 /home/$user /home/$user/.config /usr/share/archbox
chmod -R 755 /home/touriste/.bashrc /home/$user/.bashrc /home/$user/.gtkrc-2.0 /home/$user/.config /usr/share/archbox
echo -e "$white$ok Ajout dossier $user et .bashrc $red"
################################################################################################################



################################################################################################################
#------------------------------------------------------------------------------------------------------
# Choice install scripts
#------------------------------------------------------------------------------------------------------
read -p "Voulez vous installer le logiciel XBMC Oui ? Non ? [def:Non] : " ixbmc
case $ixbmc in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		ixbmc="ok" ;; 
	*)
		;;
esac
read -p "Voulez vous installer le bureau XFCE/LXDE(RPI) Oui ? Non ? [def:Non] : " ixfce
case $ixfce in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		ixfce="ok" ;; 
	*)
		;;
esac
read -p "Voulez vous installer le logiciel d'emulation Oui ? Non ? [def:Non] : " iemul
case $iemul in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		iemul="ok" ;; 
	*)
		;;
esac

idebug="ko"

if [ "$ixbmc" = "ok" ] || [ "$ixfce" = "ok" ] || [ "$iemul" = "ok" ] ; then
	echo -e "Installation des programmes basic"	
else
	read -p "Voulez vous passer en debug - Oui ? Non ? [def:Non] : " idebug
	case $idebug in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
			idebug="ok" ;; 
		*)
			;;
	esac
fi
################################################################################################################

echo ""
echo ""

################################################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green *$cyan Merci, vous pouvez aller boire un coup..."
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
read -p "Appuyer sur une touche pour continuer ..."
################################################################################################################

echo ""

################################################################################################################
#------------------------------------------------------------------------------------------------------
# Add some deposits
#------------------------------------------------------------------------------------------------------
if [ "$idebug"="ko" ] ; then
	sed -i 's/^SyncFirst = pacman/SyncFirst = pacman yaourt package-query pacman-color pyalpm namcap/' /etc/pacman.conf
	sed -i 's/^#SigLevel = Optional TrustedOnly/SigLevel = Optional TrustedOnly/' /etc/pacman.conf

	echo "" >> /etc/pacman.conf
	echo "[archlinuxfr]" >> /etc/pacman.conf
	echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf

	echo -e "$white$ok Ajout des depots libre et non libre(yaourt)"
	echo -e "$white$ok Configuration des sources /etc.pacman.conf"

	if [ -z "$archi" ] ; then
		echo "Probleme de detection d'architecture ... Veuiller vérifier : uname -m"
		exit
	else
		#------------------------------------------------------------------------------------------------------
		# if x86_64
		#------------------------------------------------------------------------------------------------------
		if [ "$archi" = "x86_64" ] ; then
			echo "Server = http://repo.archlinux.fr/x86_64" >> /etc/pacman.conf
			echo "" >> /etc/pacman.conf
			echo '[multilib]' >> /etc/pacman.conf
			echo 'SigLevel = PackageRequired' >> /etc/pacman.conf
			echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
		fi

		#------------------------------------------------------------------------------------------------------
		# if i686
		#------------------------------------------------------------------------------------------------------
		if [ "$archi" = "i686" ] ; then
			echo "Server = http://repo.archlinux.fr/i686" >> /etc/pacman.conf
		fi

		#------------------------------------------------------------------------------------------------------
		# Raspberry PI
		#------------------------------------------------------------------------------------------------------
		if [ "$archi" = "rpi" ] || [ "$archi" = "armv6l" ] ; then
			echo "Server = http://repo.archlinux.fr/arm" >> /etc/pacman.conf
		fi
		echo -e "$white$ok Ajout $archi dans repo.archlinux.fr $cyan"
	fi
fi
################################################################################################################


################################################################################################################
#------------------------------------------------------------------------------------------------------
# Install basic programs for archlinux
#------------------------------------------------------------------------------------------------------
pacman -Syy --noconfirm
echo -e "$white$ok Synchronisation sur $cyan$archi $green"
echo -e "Configuration des programmes de bases ... $cyan"
# Linux-headers - Header files and scripts for building modules for Linux kernel
# Yaourt 		- Yet AnOther User Repository Tool
# Yajl 			- Yet Another JSON Library.
# Namcap 		- is a tool to check binary packages and source PKGBUILDs for common packaging mistakes
pacman -S --noconfirm linux-headers yaourt yajl namcap 
# xorg 			- The X.Org project provides an open source implementation of the X Window System.
pacman -S --noconfirm xorg-server xorg-xinit xorg-utils xorg-server-utils xorg-fonts-type1
# Drivers touchpad - mouse - keyboard + numlock
pacman -S --noconfirm xf86-input-synaptics xf86-input-mouse xf86-input-keyboard numlockx
# colordiff 	- The Perl script colordiff is a wrapper for 'diff' and produces the same output but with pretty 'syntax' highlighting. Colour schemes can be customized.
pacman -S --noconfirm colordiff  gsfonts ttf-dejavu artwiz-fonts font-bh-ttf font-bitstream-speedo sdl_ttf ttf-bitstream-vera ttf-cheapskate ttf-liberation
# Unrar Unace 	- cmd extractor
# wget 			- cmd download manager
pacman -S --noconfirm unrar unace wget lftp lrzip
# Vim 			- text editor with colors
# Ntp 			- Network Time Protocol is the most common method to synchronize the software clock of a GNU/Linux system with internet time servers. 
# Screen 		- GNU Screen is a wrapper that allows separation between the text program and the shell from which it was launched
pacman -S --noconfirm vim ntp screen
# OpenSSL 		- is an open-source implementation of the SSL and TLS protocols, dual-licensed under the OpenSSL and the SSLeay licenses (careful with heartbleed)
# OpenSsh 		- remote server in SSH
# SSHguard 		- is a daemon that protects SSH and other services against brute-force attacts, similar to fail2ban.
# Fail2ban 		- scans various textual log files and bans IP that makes too many password failures by updating firewall rules to reject the IP address, similar to Sshguard.
# Iptables 		- is a powerful firewall built into the Linux kernel and is part of the netfilter project.
# Netctl 		- is a CLI-based tool used to configure and manage network connections via profiles. It is a native Arch Linux project that replaces the old netcfg utility.
pacman -S --noconfirm openssl openssh sshguard fail2ban iptables netctl

pacman -S --noconfirm libxvmc upower polkit ntfs-3g nfs-utils udisks udevil mtools dosfstools exfat-utils
# Configuration AUDIO avec alsa et pulseaudio (flac=codec)
cat /proc/asound/cards
pacman -S --noconfirm alsa-utils alsa-lib alsa-oss alsa-tools alsa-plugins alsa-firmware pulseaudio pulseaudio-alsa flac 
pacman -S --noconfirm lib32-libpulse
# ossp			- OSS Proxy Daemon is a Linux userland OSS sound device (/dev/[a]dsp and /dev/mixer) implementation using CUSE. Currently it supports forwarding OSS sound streams to PulseAudio and ALSA.
# paprefs 		- A simple GTK-based configuration dialog for PulseAudio
# vorbis-tools 	- Vorbis audio compression
pacman -S --noconfirm ossp paprefs vorbis-tools
echo -e "$white$ok programmes de bases"
################################################################################################################


################################################################################################################
echo -e "Configuration des programmes basiques ..."
#------------------------------------------------------------------------------------------------------
# Config Xorg
#------------------------------------------------------------------------------------------------------
cat <<EOF >/etc/X11/xorg.conf.d/10-keyboard-layout.conf
Section "InputClass"
	Identifier	"Keyboard Layout"
	MatchIsKeyboard	"yes"
	MatchDevicePath	"/dev/input/event*"
	Option	"XkbLayout"	"fr"
	Option	"XkbVariant"	"latin9"
EndSection
EOF
echo -e "Plus d'info voir : /etc/X11/xorg.conf.d/10-keyboard-layout.conf"
echo -e "$white$ok Configuration XORG KEYBOARD LAYOUT"

#------------------------------------------------------------------------------------------------------
# Config /etc/vimrc
#------------------------------------------------------------------------------------------------------
if [ "$idebug"="ko" ] ; then # check if vimrc are already created
	touch /etc/vimrc
	echo "set nu" >> /etc/vimrc
	echo "syntax on" >> /etc/vimrc
	echo "colorscheme darkblue" >> /etc/vimrc
	echo -e "Plus d'info voir : /etc/vimrc"
	echo -e "$white$ok Configuration de VIM"
fi


################################################################################################################


################################################################################################################
echo -e "Configuration du réseau et du dossier /link ..."
#------------------------------------------------------------------------------------------------------
# Repertory of link
#------------------------------------------------------------------------------------------------------
mkdir /link
mkdir /link/Logs
cp -R $rep/tools/archbox-theme/archbox_tools /link/
chown -R $user:users /link
echo -e "$white$ok Droits utilisateur $user sur /link"

#------------------------------------------------------------------------------------------------------
# Repertory of samba
#------------------------------------------------------------------------------------------------------
echo -e "Configuration des dossiers de partage reseau ..."
mkdir /media/Partage
mkdir /media/Usb
ln -s /media $HOME/Media
chown -R $user:users /media/Partage /media/Usb
echo -e "$white$ok SAMBA repertoire /media/Partage !"
echo -e "$white$ok SAMBA repertoire /media/Usb !"
echo -e "Plus d'info voir : /etc/samba/smb.conf $white"
echo -e "$white$ok Configuration des dossiers de partage"

#------------------------------------------------------------------------------------------------------
# SSH configuration 
#------------------------------------------------------------------------------------------------------
cp $rep/tools/archbox-boot/sshd_config /etc/ssh/
echo -e "Configuration SSH ..."
echo -e "Port : 443 "
echo -e "Connection uniquement sur : touriste"
echo -e "Connection désactivé sur : root & $user"
echo -e "Plus d'info voir : /etc/ssh/sshd_config"
echo -e "$white$ok Configuration SSH"
################################################################################################################


################################################################################################################
echo "Activation des services au démarrage ..."
if [ "$idebug"="ko" ] ; then
	#------------------------------------------------------------------------------------------------------
	# Serveur de temps FR (sauf Raspberry pi)
	#------------------------------------------------------------------------------------------------------
	if [ "$archi" <> "rpi" ] ; then
		rm /etc/ntp.conf 2>/dev/null
		cat <<EOF >/etc/ntp.conf
server 0.fr.pool.ntp.org iburst
server 1.fr.pool.ntp.org iburst
server 2.fr.pool.ntp.org iburst
server 3.fr.pool.ntp.org iburst

restrict default noquery nopeer
restrict 127.0.0.1
restrict ::1

driftfile /var/lib/ntp/ntp.drift
EOF
		ntpd -q
		systemctl enable ntpd.service
		echo -e "$white$ok Serveur de temps FR"
	fi
fi
systemctl enable sshd.service
systemctl enable smbd.service
systemctl enable nmbd.service
systemctl enable smbnetfs.service
echo -e "$white$ok Activation des services"
################################################################################################################


################################################################################################################
echo -e "$white"
#------------------------------------------------------------------------------------------------------
# XBMC script launch
#------------------------------------------------------------------------------------------------------
if [ "$ixbmc" = "ok" ] ; then
	if [ -f $rep/archbox_2xbmc.sh ] ; then
		sh $rep/archbox_2xbmc.sh "$user" "$archi"
	else
		echo -e "Le fichier archbox_2xbmc.sh n'est pas présent"
	fi
fi

#------------------------------------------------------------------------------------------------------
# XFCE script launch
#------------------------------------------------------------------------------------------------------
if [ "$ixfce" = "ok" ] ; then
	if [ -f $rep/archbox_3desktop.sh ] ; then
		sh $rep/archbox_3desktop.sh "$user" "$archi"
	else
		echo -e "Le fichier archbox_3desktop.sh n'est pas présent"
	fi
fi

#------------------------------------------------------------------------------------------------------
# Emulateurs script launch
#------------------------------------------------------------------------------------------------------
if [ "$iemul" = "ok" ] ; then
	if [ -f $rep/archbox_4emulateur.sh ] ; then
		sh $rep/archbox_4emulateur.sh "$user" "$archi"
	else
		echo -e "Le fichier archbox_4emulateur.sh n'est pas présent"
	fi
fi


if [ "$idebug"="ko" ] ; then
	#------------------------------------------------------------------------------------------------------
	# DRIVERS script launch
	#------------------------------------------------------------------------------------------------------
	if [ -f $rep/archbox_5drivers.sh ] ; then
		sh $rep/archbox_5drivers.sh "$user" "$archi"
	else
		echo -e "Le fichier archbox_5drivers.sh n'est pas présent"
	fi
	#------------------------------------------------------------------------------------------------------
	# BOOT script launch
	#------------------------------------------------------------------------------------------------------
	if [ -f $rep/archbox_6boot.sh ] ; then
		sh $rep/archbox_6boot.sh "$user" "$archi"
	else
		echo -e "Le fichier archbox_6boot.sh n'est pas présent"
	fi
fi

cat <<EOF > $rep/1config.lck
#----------------------------
# ARCHBOX_1CONFIG.SH --> [OK]
#----------------------------
EOF
################################################################################################################


################################################################################################################
echo -e "$green **********************************************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon"
echo -e "$green * Installation $yellow [ARCHBOX]$red Terminé"	
echo -e "$green * "
echo -e "$green ********************************************************************************************************** $nc"
################################################################################################################
