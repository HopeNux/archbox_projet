#!/bin/bash
clear
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_1CONFIG.SH --> DEBUT
#----------------------------------------------------------------
rep=`(cd $(dirname "$0"); pwd)` &>/dev/null
loadkeys fr-pc
export LANG=fr_FR.UTF-8
export blue="\\033[1;34m"
export cyan="\\033[1;36m"
export green="\\033[1;32m"
export nc="\\033[0;39m"
export red="\\033[1;31m"
export white="\\033[1;37m"
export yellow="\\033[1;33m"
archi=`uname -m`
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "
echo " "
echo -e "$white ******************************************************************************"
echo -e "$white * Définition du répertoire source $rep "
echo -e "$white * Configuration de la langue [FR]"

#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/1config.lck"
rm $rep/1config.lck
echo -e "$white * "

#----------------------------------------------------------------
# Config /etc/localtime
#----------------------------------------------------------------
rm /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo -e "$white * /etc/localtime $yellow [OK]"
echo -e "$white * "

#----------------------------------------------------------------
# Config /etc/locale.conf
#----------------------------------------------------------------
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo -e "$white * /etc/locale.conf $yellow [OK]"
echo -e "$white *"

#----------------------------------------------------------------
# Config /etc/timezone
#----------------------------------------------------------------
echo "Europe/Paris" > /etc/timezone

#----------------------------------------------------------------
# Config /etc/locale.gen
#----------------------------------------------------------------
sed -i 's/^#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#fr_FR ISO-8859-1/fr_FR ISO-8859-1/' /etc/locale.gen
sed -i 's/^#fr_FR@euro ISO-8859-15/fr_FR@euro ISO-8859-15/' /etc/locale.gen
locale-gen
echo -e "$white * /etc/locale.gen $yellow [OK]"
echo -e "$white * "
#----------------------------------------------------------------
# Mise à jour + Installation
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
echo -e "$white * "
echo -e "$white * Installation : net-tools - samba - smbclient"
echo -e " * $cyan"
pacman -S --noconfirm net-tools samba smbclient
cp $rep/tools/archbox-network/smb.conf /etc/samba/
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "
echo " "
echo " "

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green *$white Saisie de l'utilisateur..."
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e " * $red" 
read -p " * Nom de votre machine : " nomdupc
if [ -z "$nomdupc" ] ; then
    echo "ARCHBOX" > /etc/hostname
	nomdupc="ARCHBOX"
else
	echo $nomdupc > /etc/hostname
fi
echo -e "$green *"
#----------------------------------------------------------------
# Config touriste
#----------------------------------------------------------------
echo -e "$green * (1)  -> Installation et configuration de l'utilisateur 'touriste'"
echo -e "$green *      -> avec le partage réseau"
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power -s /bin/bash touriste
echo -e "$green        ->$red Mot de passe 'touriste' SSH : $nc"
passwd touriste
echo -e "$green *"
echo -e "$green *      ->$red Mot de passe 'touriste' SAMBA (partage réseau) : $nc"
smbpasswd -a touriste
echo -e "$green *"
echo -e "$green *      -> Ajout du 'touriste' dans le groupe $white USERS : $nc"
gpasswd -a touriste users
echo -e "$green * Ajout .bashrc touriste $yellow [OK]"
echo -e "$green * "
#----------------------------------------------------------------
# Config new user (defaut xbmc)
#----------------------------------------------------------------
groupadd xbmc
read -p " * Nouveau utilisateur : (défaut xbmc) " user
if [ -z "$user" ] ; then
	user="xbmc"
fi
echo -e "$green * Installation et configuration de l'utilisateur $user"
echo -e "$white * (2)  -> Ajout utilisateur '$user' "
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,xbmc $user
echo -e "$white *      -> Ajout du mot de passe 'xbmc' (pas de connection SSH) : $nc "
passwd $user
echo -e "$white * "
gpasswd -a $user users
gpasswd -a touriste xbmc
echo -e "$white * Utilisateur $user $yellow [OK]"

#----------------------------------------------------------------
# Config root
#----------------------------------------------------------------
echo -e "$green * (3)  -> Configuration utilisateur 'root'" 
echo -e "$green *      -> $red Mot de passe 'root' (pas de connection SSH) : $nc"
passwd
echo -e "$green *"

#----------------------------------------------------------------
# Config root / touriste / user .bashrc
#----------------------------------------------------------------
rm /home/touriste/.bashrc &>/dev/null
cp $rep/tools/archbox-theme/bashrc /home/touriste/.bashrc
chown touriste:users /home/touriste/.bashrc
rm /home/$user/.bashrc &>/dev/null
cp $rep/tools/archbox-theme/bashrc /home/$user/.bashrc
chown $user:users /home/$user/.bashrc
cp $rep/tools/archbox-theme/bashrc /root/.bashrc
echo -e "$green * Ajout .bashrc$yellow [OK]"
echo -e "$green * "

#----------------------------------------------------------------
# Architecture (i386 - i686 - x86_64 - armv6l)
#----------------------------------------------------------------
echo -e "$green * Votre architecture$yellow $archi"
if [ "$archi" = "armv6l" ] ; then
	echo -e " * $red"
	read -p " * Votre machine est elle un Raspberry Pi Oui ? Non ? [def:Non] : " rpi
	case $rpi in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
			archi="rpi" ;; 
		*)
			echo " * " ;;
	esac
fi
#----------------------------------------------------------------
# Config /etc/vconsole.conf
#----------------------------------------------------------------
if [ "$archi" = "rpi" ] ; then
	echo "KEYMAP=fr-pc" >> /etc/vconsole.conf	
else
	echo "KEYMAP=fr-pc" > /etc/vconsole.conf
fi
echo "FONT=" >> /etc/vconsole.conf
echo "FONT_MAP=" >> /etc/vconsole.conf
echo -e "$white * Mise à jour langue dans /etc/vconsole.conf $yellow [OK]"

#----------------------------------------------------------------
# Choix scripts d'installation
#----------------------------------------------------------------
echo -e "$white * $red"

read -p " * Voulez vous installer le logiciel XBMC Oui ? Non ? [def:Non] : " ixbmc
case $ixbmc in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		ixbmc="ok" ;; 
	*)
		echo " * " ;;
esac

echo -e " * $red"
read -p " * Voulez vous installer un bureau XFCE Oui ? Non ? [def:Non] : " ixfce
case $ixfce in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		ixfce="ok" ;; 
	*)
		echo " * " ;;
esac
echo -e " * $red"
read -p " * Voulez vous installer un logiciel d'emulation Oui ? Non ? [def:Non] : " iemul
case $iemul in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		iemul="ok" ;; 
	*)
		echo " * " ;;
esac
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################

echo ""
echo ""

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green *$white Merci, vous pouvez aller boire un coup..."
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo -e " * $red"
read -p " * Appuyer sur une touche pour continuer ..."
###############################################################################################

echo ""
echo ""

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Configuration des sources --> /etc.pacman.conf"
echo -e "$white * Paquets libre et non libre + Yaourt"

#----------------------------------------------------------------
# Ajout depots
#----------------------------------------------------------------
sed -i 's/^SyncFirst   = pacman/SyncFirst = pacman yaourt package-query pacman-color pyalpm namcap/' /etc/pacman.conf
sed -i 's/^#SigLevel = Optional TrustedOnly/SigLevel = Optional TrustedOnly/' /etc/pacman.conf
echo "" >> /etc/pacman.conf
echo "[archlinuxfr]" >> /etc/pacman.conf
echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf

#----------------------------------------------------------------
# SI x86_64
#----------------------------------------------------------------
if [ "$archi" = "x86_64" ] ; then
	echo "Server = http://repo.archlinux.fr/x86_64" >> /etc/pacman.conf
	echo "" >> /etc/pacman.conf
	echo '[multilib]' >> /etc/pacman.conf
	echo 'SigLevel = PackageRequired' >> /etc/pacman.conf
	echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
fi

#----------------------------------------------------------------
# SI i686
#----------------------------------------------------------------
if [ "$archi" = "i686" ] ; then
	echo "Server = http://repo.archlinux.fr/i686" >> /etc/pacman.conf
fi

#----------------------------------------------------------------
# SI RPI
#----------------------------------------------------------------
if [ "$archi" = "rpi" ] || [ "$archi" = "armv6l" ] ; then
	echo "Server = http://repo.archlinux.fr/arm" >> /etc/pacman.conf
fi
echo -e "$white * Ajout repo.archlinux.fr $yellow [OK]"
echo -e "$white * $cyan "
pacman -Syy --noconfirm
echo -e "$white * Synchronisation sur$yellow $archi [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Installation des programmes basiques ..."
echo -e " * $cyan "
pacman -S --noconfirm yaourt yajl namcap dosfstools
pacman -S --noconfirm xorg-server xorg-xinit xorg-utils xorg-server-utils xterm xorg-fonts-type1 numlockx colordiff
pacman -S --noconfirm ttf-dejavu artwiz-fonts font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf ttf-bitstream-vera ttf-cheapskate ttf-liberation
pacman -S --noconfirm subversion dbus dbus-python python-cairo python2-cairo
pacman -S --noconfirm vim ntp
pacman -S --noconfirm openssl sshguard iptables
pacman -S --noconfirm libxvmc upower polkit ntfs-3g nfs-utils udisks udevil mtools # mtools=acces msdos disks
pacman -S --noconfirm alsa-utils alsa-lib alsa-oss alsa-tools alsa-plugins alsa-firmware pulseaudio pulseaudio-alsa ossp paprefs pavucontrol lib32-libpulse flac vorbis-tools gstreamer0.10-base
echo -e "$white * Outils de base $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Configuration des programmes basiques ..."
echo -e "$white * voir : /etc/X11/xorg.conf.d/10-keyboard-layout.conf"

#----------------------------------------------------------------
# Config Xorg
#----------------------------------------------------------------
	cat <<EOF >/etc/X11/xorg.conf.d/10-keyboard-layout.conf
Section "InputClass"
	Identifier	"Keyboard Layout"
	MatchIsKeyboard	"yes"
	MatchDevicePath	"/dev/input/event*"
	Option	"XkbLayout"	"fr"
	Option	"XkbVariant"	"latin9"
EndSection
EOF
echo -e "$white * Configuration XORG KEYBOARD LAYOUT $yellow [OK]"

#----------------------------------------------------------------
# Serveur de temps FR
#----------------------------------------------------------------
if [ ! "$archi" = "rpi" ]  ; then
	rm /etc/ntp.conf &>/dev/null
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
	echo -e "$white * Serveur de temps FR $yellow [OK]"
fi

#----------------------------------------------------------------
# Config /etc/vimrc
#----------------------------------------------------------------
touch /etc/vimrc
sed -i 16i"syntax on" /etc/vimrc
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Configuration du réseau"
echo -e "$white * Utilisateur touriste sur /link/"
echo -e "$white * SAMBA /link/Partage"
echo -e "$white * SAMBA /link/Usb"
echo -e "$white * SAMBA /link/Usb2"
echo -e "$white * voir : /etc/samba/smb.conf"
mkdir /link
mkdir /link/Partage
mkdir /link/Usb
mkdir /link/Usb2
chmod -R 750 /link
chmod -R 777 /link/Partage
chown -R $user:users /link
echo -e "$white * Configuration du réseau $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Configuration SSH "
echo -e "$white * Port : 443 "
echo -e "$white * Connection unique : touriste"
echo -e "$white * Connection root : désactivé"
echo -e "$white * Config /etc/ssh/sshd_config"
cp $rep/tools/archbox-boot/sshd_config /etc/ssh/
echo -e "$white * Configuration SSH $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo "* Activation des services au démarrage ..."
systemctl enable dbus.service
systemctl enable ntpd.service
systemctl enable sshd.service
systemctl enable acpid.service
systemctl enable smbd.service nmbd.service
echo -e "$white * Activation des services $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# ARCHBOX_1CONFIG.SH --> LANCEMENT DES AUTRES SCRIPTS
#----------------------------------------------------------------
if [ "$ixbmc" = "ok" ] ; then
	if [ -f $rep/archbox_2xbmc.sh ] ; then
		sh $rep/archbox_2xbmc.sh "$user"
	else
		echo -e "$red * Le fichier archbox_2xbmc.sh n'est pas présent"
	fi
fi
if [ "$ixfce" = "ok" ] ; then
	if [ -f $rep/archbox_3desktop.sh ] ; then
		sh $rep/archbox_3desktop.sh
	else
		echo -e "$red * Le fichier archbox_3desktop.sh n'est pas présent"
	fi
fi
if [ "$iemul" = "ok" ] ; then
	if [ -f $rep/archbox_4emulateur.sh ] ; then
		sh $rep/archbox_4emulateur.sh
	else
		echo -e "$red * Le fichier archbox_4emulateur.sh n'est pas présent"
	fi
fi
if [ -f $rep/archbox_5drivers.sh ] ; then
	sh $rep/archbox_5drivers.sh
else
	echo -e "$red * Le fichier archbox_5drivers.sh n'est pas présent"
fi
if [ -f $rep/archbox_6boot.sh ] ; then
	sh $rep/archbox_6boot.sh
else
	echo -e "$red * Le fichier archbox_6boot.sh n'est pas présent"
fi
echo -e " * $white "
echo -e "$green **********************************************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green *$yellow Installation terminé voir les logs"
echo -e "$green * "
echo -e "$green ********************************************************************************************************** $nc"
cat <<EOF > $rep/1config.lck
#----------------------------------------------------------------
# ARCHBOX_1CONFIG.SH --> [OK]
#----------------------------------------------------------------
EOF
###############################################################################################