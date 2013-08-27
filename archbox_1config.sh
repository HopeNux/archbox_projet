#!/bin/sh
loadkeys fr-pc
export LANG=fr_FR.UTF-8
clear
echo "******************************************************************************"
echo "*# 														   				  #*"
echo "*# [ ARCHBOX ]											   				  #*"
echo "*# Votre console multimédia de salon 						   				  #*"
echo "*# 														   				  #*"
echo "******************************************************************************"
echo "******************************************************************************"
echo "* Installation ARCHBOX"
echo "* "
echo "* Installation en natif [OFF]"
echo "* "
echo "******************************************************************************"
rep=`(cd $(dirname "$0"); pwd)`
echo "* Définition du répertoire source $rep "
echo "******************************************************************************"
echo "* Nom de votre ordinateur source:/etc/hostname"
echo "******************************************************************************"
echo "* Nom de la machine :"
read nomdupc
if [[ -z "$nomdupc" ]] ; then
    echo "ARCHBMC" > /etc/hostname
	nomdupc="ARCHBMC"
else
	echo $nomdupc > /etc/hostname
fi
export nomdupc
echo ""
echo "******************************************************************************"
echo "* Configuration de la langue [FR]"
echo "******************************************************************************"

# Config /etc/vconsole.conf
echo "KEYMAP=fr-pc" > /etc/vconsole.conf
echo "FONT=" >> /etc/vconsole.conf
echo "FONT_MAP=" >> /etc/vconsole.conf
echo "* /etc/vconsole.conf [OK]"

# Config /etc/localtime
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo "* /etc/localtime [OK]"

# Config /etc/locale.conf
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "* /etc/locale.conf [OK]"

# Config /etc/timezone
echo "Europe/Paris" > /etc/timezone

# Config /etc/locale.gen
sed -i 's/^#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#fr_FR ISO-8859-1/fr_FR ISO-8859-1/' /etc/locale.gen
sed -i 's/^#fr_FR@euro ISO-8859-15/fr_FR@euro ISO-8859-15/' /etc/locale.gen
locale-gen
echo "* /etc/locale.gen [OK]"
echo "******************************************************************************"
echo "* Mise à jour "
echo "******************************************************************************"
pacman -Suy --noconfirm
pacman -S --noconfirm net-tools openssh samba smbclient vim ntp

# Serveur de temps FR
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
systemctl start ntpd.service
systemctl enable ntpd.service
hwclock --systohc --utc

# Config /etc/vimrc
touch /etc/vimrc
sed -i 17i"syntax on" /etc/vimrc
sed -i 18i"set nu" /etc/vimrc

# Config Samba
cp $rep/tools/archbox-network/smb.conf /etc/samba/

echo ""
echo ""
echo "******************************************************************************"
echo "* (1) -> Ajout d'un utilisateur 'touriste' pour le partage public réseau"
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power -s /bin/bash touriste
echo "* (1.1) -> $white Ajout du mot de passe 'touriste' pour la connexion SSH :$nc"
passwd touriste
echo "* (1.2) -> $white Ajout du mot de passe 'touriste' pour la connexion SAMBA :$nc"
smbpasswd -a touriste
echo "* (1.3) -> $white Ajout du 'touriste' dans le groupe users :$nc"
gpasswd -a touriste users
echo "******************************************************************************"
echo "* (2) -> Configuration de l'utilisateur 'root'" 
echo "* (2.1) -> $white Ajout du mot de passe 'root' pas de connection SSH :$nc"
passwd
echo "******************************************************************************"
echo "* (3) -> Ajout d'un utilisateur XBMC 'xbmc' pour le logiciel XBMC"
groupadd xbmc
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,xbmc xbmc
echo "* (3.1) -> $white Ajout du mot de passe 'xbmc' pas de connection SSH :$echo nc"
echo "******************************************************************************"
echo "* (4) -> Ajout d'un utilisateur 'dbmc'" 
echo "         pour l'environnement de bureau"
groupadd dbmc
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,dbmc dbmc
echo "* (4.1) -> $white Ajout du mot de passe 'dbmc'" 
echo "         pas de connection SSH :$echo nc"
echo "******************************************************************************"
echo ""

echo "******************************************************************************"
echo "* Architecture (i386 - i686 - x86_64 - armv6l)"
echo "******************************************************************************"sh _bas
archi=`uname -m`
 if [ "$archi" = "armv6l" ]
 then
	echo "* Votre machine est elle un Raspberry Pi " ?
	echo -n "* Oui ? Non ? [Non] : "
	read rpi
	case $rpi in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		archi="rpi" ;;
 
		*)
		echo ;;
	esac
fi
echo ""

echo "******************************************************************************"
echo "* IP Fixe de l'ordinateur"
echo "******************************************************************************"
ifconfig 
echo "* Veuillez saisir le nom de votre carte réseau"
read cartereseau
export ip=192.168.1.77
ip="192.168.1.77"
echo "* Config IP FIXE"
echo "* Souhaitez-vous definir une adresse IP fixe ?"
echo -n "* Oui ? Non ? [Non] : "
read REP
case $REP in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
	echo "* Veuillez saisir l'adresse IP souhaité"
	read ip
	echo "* Veuillez saisir l'adresse du masque de sous réseau"
	read mask
	echo "* Veuillez saisir l'adresse de la passerelle par défaut"
    read gateway
	systemctl disable dhcpcd@$card.service
	echo "* Votre ip : "$ip
	echo "interface=enp2s2" > /etc/conf.d/network
	echo "address="$ip"" >> /etc/conf.d/network
	echo "netmask=255.255.255.0" >> /etc/conf.d/network
	echo "broadcast=192.168.1.255" >> /etc/conf.d/network
	echo "gateway=192.168.1.1" >> /etc/conf.d/network
	cp $rep/tools/archbox-network/network.service /etc/systemd/system/	
	echo " ARCHBOX " > /etc/resolv.conf
	echo " Configuration DNS [1:8.8.8.8 / 2:8.8.4.4]" >> /etc/resolv.conf
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	echo "nameserver 8.8.4.4" >> /etc/resolv.conf
	systemctl enable network.service ;;
	*)
	systemctl enable dhcpcd@$card.service ;;
esac
echo ""
clear
echo "******************************************************************************"
echo "* "
echo "* "
echo "* "
echo "* "
echo "* "
echo "* "
echo "* --> Installation en natif [ON]"
echo "* "
echo "* "
echo "* "
echo "* "
echo "* "
echo "* "
echo "******************************************************************************"
echo ""
echo ""

#NO RPI
if [ "$archi" = "x86_64" ] || [ "$archi" = "i686" ]  ; then
	echo "******************************************************************************"
	# Configurez /etc/mkinitcpio.conf et créez les ramdisk avec 
	mkinitcpio -p linux
	echo "* mkinitcpio [OK]"
	echo ""
	echo "******************************************************************************"
	echo "* Configuration de syslinux (boot)"
	echo "******************************************************************************"
	pacman -S syslinux
	syslinux-install_update -iam
	echo "* Syslinux [OK]"
	echo ""
fi

echo "******************************************************************************"
echo "* Configuration de l'utilisateur ROOT"
echo "******************************************************************************"
# Config /root/.bashrc
cp $rep/tools/archbox-theme/.bashrc /root/.bashrc
echo "* /root/.bashrc [OK]"
echo ""

echo "******************************************************************************"
echo "* Configuration des sources"
echo "*    /etc.pacman.conf"
echo "* Paquets libre et non libre + Yaourt"
echo "******************************************************************************"

# Ajout depots
sed -i 's/^SyncFirst   = pacman/SyncFirst = pacman yaourt package-query pacman-color pyalpm namcap/' /etc/pacman.conf
sed -i 's/^#SigLevel = Optional TrustedOnly/SigLevel = Optional TrustedOnly/' /etc/pacman.conf
echo '' >> /etc/pacman.conf
echo "[archlinuxfr]" >> /etc/pacman.conf
echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf
# SI x86_64
if [ "$archi" = "x86_64" ] ; then
	echo "Server = http://repo.archlinux.fr/x86_64" >> /etc/pacman.conf
	echo ""
	echo '[multilib]' >> /etc/pacman.conf
	echo 'SigLevel = PackageRequired' >> /etc/pacman.conf
	echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
fi
# SI i686
if [ "$archi" = "i686" ] ; then
	echo "Server = http://repo.archlinux.fr/i686" >> /etc/pacman.conf
fi
# SI RPI
if [ "$archi" = "rpi" ] || [ "$archi" = "armv6l" ] ; then
	echo "Server = http://repo.archlinux.fr/arm" >> /etc/pacman.conf
fi
pacman -Syy
echo "* Ajout repo.archlinux.fr [OK]"
echo ""


echo "******************************************************************************"
echo "* Installation des programmes basiques ..."
echo "******************************************************************************"
pacman -Sy
echo "* Synchronisation [OK]"
pacman -Su --noconfirm subversion portaudio dbus-python python-cairo python2-cairo 
pacman -Su --noconfirm wget gstreamer0.10-base pcmanfm acpi acpid openssl pulseaudio pulseaudio-alsa alsa-plugins ntfs-3g nfs-utils
pacman -Su --noconfirm unrar p7zip lftp mtools dosfstools numlockx flac vorbis-tools links dbus xdg-user-dirs
echo "* Outils de base (1) [OK]"
pacman -Su --noconfirm yaourt yajl namcap colordiff
echo "* Outils de base (2) [OK]"
pacman -Su --noconfirm xorg-fonts-type1 ttf-dejavu artwiz-fonts font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf ttf-bitstream-vera ttf-cheapskate ttf-liberation
echo "* Outils de base (3) - lissage des polices [OK]"
pacman -Su --noconfirm sshguard iptables
echo "* Outils de base (4) - Sécurité sshguard + iptables [OK]"
pacman -Su --noconfirm xorg-server xorg-xinit xorg-utils xorg-server-utils xterm
echo "* Outils de base (5) Xorg [OK]"
echo ""

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

echo "******************************************************************************"
echo "* Configuration du réseau"
echo "* Utilisateur touriste sur /link/"
echo "* SAMBA /link/Partage"
echo "* SAMBA /link/Usb"
echo "* SAMBA /link/Usb2"
echo "* SAMBA /etc/samba/smb.conf <--Configuration"
echo "******************************************************************************"
mkdir /link
mkdir /link/Partage
mkdir /link/Usb
mkdir /link/Usb2
chown -R touriste:users /link
cp $rep/tools/archbox-theme/.bashrc /home/touriste/.bashrc
chown touriste:users /home/touriste/.bashrc
chmod -R 750 /link
echo ""

echo "******************************************************************************"
echo "* Configuration SSH "
echo "*  Port : 443 "
echo "*  Connection unique : touriste"
echo "*  Connection root : désactivé"
echo "*  Config /etc/ssh/sshd_config"
echo "******************************************************************************"
cp $rep/tools/archbox-boot/sshd_config /etc/ssh/
echo ""

echo "******************************************************************************"
echo "* Activation des services au démarrage ..."
echo "******************************************************************************"
systemctl enable sshd.service
systemctl enable acpid.service
systemctl enable smbd.service 
systemctl enable nmbd.service
echo ""