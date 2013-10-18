#!/bin/bash
clear
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_1CONFIG.SH --> DEBUT
#----------------------------------------------------------------
rep=`(cd $(dirname "$0"); pwd)` 2>/dev/null
echo "script lancé depuis : $rep"
#----------------------------------------------------------------
# Script des paramètres par défauts
#----------------------------------------------------------------
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
#----------------------------------------------------------------
# Vérification / Creation fichier LOG
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "log" "$rep/archbox_1config.log"
echo "" > $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# ARCHBOX_1CONFIG.SH --> DEBUT" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
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
###############################################################################################


echo " "
echo " "


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Définition du répertoire source $rep "
echo -e "$white * Configuration de la langue [FR]"
#----------------------------------------------------------------
# Config /etc/localtime
#----------------------------------------------------------------
rm /etc/localtime 2>/dev/null
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo -e "$white * /etc/localtime $yellow [OK]"
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
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG CONFIGURATION LANGUES" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "LANGUE voir : /etc/vconsole.conf" >> $rep/archbox_1config.log
echo "LANGUE voir : /etc/localtime" >> $rep/archbox_1config.log
echo "LANGUE voir : /etc/locale.conf" >> $rep/archbox_1config.log
echo "LANGUE voir : /etc/timezone" >> $rep/archbox_1config.log
echo "LANGUE voir : /etc/locale.gen" >> $rep/archbox_1config.log
echo "LANGUE [OK]" >> $rep/archbox_1config.log
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
echo -e "$green ******************************************************************************"
echo -e " * $red" 
read -p " * Nom de votre machine : " nomdupc
if [ -z "$nomdupc" ] ; then
    echo "ARCHBOX" > /etc/hostname
	nomdupc="ARCHBOX"
else
	echo $nomdupc > /etc/hostname
fi
echo -e "$green * (1) -> Ajout utilisateur 'touriste' pour le partage réseau"
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power -s /bin/bash touriste
echo -e "$green * (1.1) ->$red Mot de passe 'touriste' SSH : $nc"
passwd touriste
echo -e "$green * (1.2) ->$red Mot de passe 'touriste' SAMBA : $nc"
smbpasswd -a touriste
echo -e "$green * (1.3) -> Ajout du 'touriste' dans le groupe $white USERS : $nc"
gpasswd -a touriste users
#----------------------------------------------------------------
# Config /home/touriste/.bashrc
#----------------------------------------------------------------
rm /home/touriste/.bashrc 2>/dev/null
cp $rep/tools/archbox-theme/bashrc /home/touriste/.bashrc
chown touriste:users /home/touriste/.bashrc
echo -e "$green * Ajout .bashrc $yellow [OK]"
echo -e "$green * "
echo -e "$green * (2) -> Configuration utilisateur 'root'" 
echo -e "$green * (2.1) -> $red Mot de passe 'root' (pas de connection SSH) : $nc"
passwd
#----------------------------------------------------------------
# Config /root/.bashrc
#----------------------------------------------------------------
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
	hwclock --systohc --utc
else
	echo "KEYMAP=fr-pc" > /etc/vconsole.conf
fi
echo "FONT=" >> /etc/vconsole.conf
echo "FONT_MAP=" >> /etc/vconsole.conf
echo -e "$white * Mise à jour langue dans /etc/vconsole.conf $yellow [OK]"
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
echo -e "$white * Installation : net-tools / openssh / samba / smbclient / vim / ntp"
echo -e " * $cyan"
pacman -S --noconfirm net-tools openssh samba smbclient vim ntp
#----------------------------------------------------------------
# Serveur de temps FR
#----------------------------------------------------------------
rm /etc/ntp.conf 2>/dev/null
echo "server 0.fr.pool.ntp.org iburst" > /etc/ntp.conf
echo "server 1.fr.pool.ntp.org iburst" >> /etc/ntp.conf
echo "server 2.fr.pool.ntp.org iburst" >> /etc/ntp.conf
echo "server 3.fr.pool.ntp.org iburst" >> /etc/ntp.conf
echo "" >> /etc/ntp.conf
echo "restrict default noquery nopeer" >> /etc/ntp.conf
echo "restrict 127.0.0.1" >> /etc/ntp.conf
echo "restrict ::1" >> /etc/ntp.conf
echo "" >> /etc/ntp.conf
echo "driftfile /var/lib/ntp/ntp.drift" >> /etc/ntp.conf
ntpd -q
echo -e "$white * Serveur de temps FR $yellow [OK]"
#----------------------------------------------------------------
# Config /etc/vimrc
#----------------------------------------------------------------
touch /etc/vimrc
sed -i 16i"syntax on" /etc/vimrc
#----------------------------------------------------------------
# Config Samba
#----------------------------------------------------------------
cp $rep/tools/archbox-network/smb.conf /etc/samba/
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG CONFIGURATION Serveur de Temps - Vim - Samba" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "TEMPS voir : /etc/ntp.conf" >> $rep/archbox_1config.log
echo "VIM voir : /etc/vimrc" >> $rep/archbox_1config.log
echo "SAMBA voir : /etc/samba/smb.conf" >> $rep/archbox_1config.log
echo "CONFIGURATION [OK]" >> $rep/archbox_1config.log
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
pacman -Syu --noconfirm
echo -e "$white * Synchronisation sur$yellow $archi [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG AJOUTS DEPOTS" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "DEPOTS voir : /etc/pacman.conf" >> $rep/archbox_1config.log
echo "DEPOTS [OK]" >> $rep/archbox_1config.log
###############################################################################################


echo " "
echo " "


###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Installation des programmes basiques ..."
echo -e " * $cyan "
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG OUTILS DE BASE (1,2,3,4,5,6)" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
pacman -S --noconfirm subversion portaudio dbus-python python-cairo python2-cairo 
pacman -S --noconfirm wget gstreamer0.10-base pcmanfm acpi acpid openssl pulseaudio pulseaudio-alsa alsa-plugins ntfs-3g nfs-utils
pacman -S --noconfirm unrar p7zip lftp mtools dosfstools numlockx flac vorbis-tools links dbus xdg-user-dirs
echo -e "$white * Outils de base (1) $yellow [OK]"
echo "Outils de base (1) [OK]" >> $rep/archbox_1config.log
echo -e " * $cyan "
pacman -S --noconfirm yaourt yajl namcap colordiff
echo -e "$white * Outils de base (2) $yellow [OK]"
echo "Outils de base (2) [OK]" >> $rep/archbox_1config.log
echo -e " * $cyan "
pacman -S --noconfirm xorg-fonts-type1 ttf-dejavu artwiz-fonts font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf ttf-bitstream-vera ttf-cheapskate ttf-liberation
echo -e "$white * Outils de base (3) - lissage des polices $yellow [OK]"
echo "Outils de base (3) [OK]" >> $rep/archbox_1config.log
echo -e " * $cyan "
pacman -S --noconfirm sshguard iptables
echo -e "$white * Outils de base (4) - Sécurité sshguard + iptables $yellow [OK]"
echo "Outils de base (4) [OK]" >> $rep/archbox_1config.log
echo -e " * $cyan "
pacman -S --noconfirm xorg-server xorg-xinit xorg-utils xorg-server-utils xterm
echo -e "$white * Outils de base (5) Xorg $yellow [OK]"
echo "Outils de base (5) [OK]" >> $rep/archbox_1config.log
echo -e " * $cyan "
pacman -S --noconfirm lirc libxvmc upower polkit udisks alsa-utils udevil
echo -e "$white * Outils de base (6) Allumage, montage disque dur, sons $yellow [OK]"
echo "Outils de base (6) [OK]" >> $rep/archbox_1config.log
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "OUTILS [OK]" >> $rep/archbox_1config.log
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
touch /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "Section \"InputClass\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "	Identifier	\"Keyboard Layout\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "	MatchIsKeyboard	\"yes\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "	MatchDevicePath	\"/dev/input/event*\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "	Option	\"XkbLayout\"	\"fr\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "	Option	\"XkbVariant\"	\"latin9\"" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo "EndSection" >> /etc/X11/xorg.conf.d/10-keyboard-layout.conf
echo -e "$white * Configuration XORG $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG CONFIGURATION XORG" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "XORG voir : /etc/X11/xorg.conf.d/10-keyboard-layout.conf " >> $rep/archbox_1config.log
echo "XORG [OK]" >> $rep/archbox_1config.log
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
chown -R touriste:users /link
echo -e "$white * Configuration du réseau $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG CONFIGURATION SAMBA" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "SAMBA voir : /link/Partage" >> $rep/archbox_1config.log
echo "SAMBA voir : /etc/samba/smb.conf" >> $rep/archbox_1config.log
echo "SAMBA [OK]" >> $rep/archbox_1config.log
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
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG CONFIGURATION SSH" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "SSH voir : /etc/ssh/sshd_config" >> $rep/archbox_1config.log
echo "SSH [OK]" >> $rep/archbox_1config.log
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
systemctl enable bluetooth.service
systemctl enable smbd.service nmbd.service
echo -e "$white * Activation des services $yellow [OK]"
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# Ajout LOG
#----------------------------------------------------------------
echo "" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "# LOG ACTIVATION DES SERVICES" >> $rep/archbox_1config.log
echo "#----------------------------------------------------------------" >> $rep/archbox_1config.log
echo "SERVICE Actif au demarrage : ntpd + sshd + acpid + smbd + nmbd  " >> $rep/archbox_1config.log
###############################################################################################


echo " "
echo " "


###############################################################################################
echo -e "$white ******************************************************************************"
#----------------------------------------------------------------
# ARCHBOX_1CONFIG.SH --> FIN
#----------------------------------------------------------------
if [ "$ixbmc" = "ok" ] ; then
	sh $rep/archbox_2xbmc.sh
fi
if [ "$ixfce" = "ok" ] ; then
	sh $rep/archbox_3desktop.sh
fi
if [ "$iemul" = "ok" ] ; then
	sh $rep/archbox_4emulateur.sh
fi
sh $rep/archbox_5drivers.sh
sh $rep/archbox_6boot.sh
echo -e " * $white "
echo -e "$green **********************************************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimédia de salon" 
echo -e "$green *$yellow Installation terminé voir les logs"
echo -e "$green * "
echo -e "$green **********************************************************************************************************"
echo -e "$green * $red"
read -p " * Pour voir les logs appuyer sur un touche, sinon quitter "
echo -e "$green ****************************************************************************** $cyan"
more $rep/*.log
echo -e "$green ******************************************************************************"
###############################################################################################