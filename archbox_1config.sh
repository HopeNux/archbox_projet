#!/bin/sh
echo "***************************************************************"
echo "* Installation des programmes nécessaires aux"
echo "* bon fonctionnement d'ARCH"
echo "***************************************************************"
echo "* "
echo "* Installation en native [OFF]"
echo "* "
echo "***************************************************************"
# ajouter un control sur repertoire
# ou variable ou le sript ce lance
rep=`$(cd $(dirname "$0"); pwd)`
export LANG=fr_FR.UTF-8
pacman -Su --noconfirm net-tools openssh samba smbclient smbnetfs vim
cp configuration/smb.conf /etc/samba/
echo ""
echo "***************************************************************"
echo "* (1) -> Ajout d'un utilisateur 'touriste'" 
echo "         pour le partage public réseau"
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power -s /bin/bash touriste
echo "* (1.1) -> $white Ajout du mot de passe 'touriste'" 
echo "         pour la connexion SSH :$nc"
passwd touriste
echo "* (1.2) -> $white Ajout du mot de passe 'touriste'" 
echo "         pour la connexion SAMBA :$nc"
smbpasswd -a touriste
echo "* (1.3) -> $white Ajout du 'touriste' dans le groupe users :$nc"
gpasswd -a touriste users
echo "* (2) -> Configuration de l'utilisateur 'root'" 
echo "* (1.1) -> $white Ajout du mot de passe 'root'" 
echo "         pas de connection SSH :$nc"
passwd
echo "* (3) -> Ajout d'un utilisateur 'xbmc'" 
echo "         pour le logiciel XBMC"
groupadd xbmc
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,xbmc xbmc
echo "* (1.1) -> $white Ajout du mot de passe 'xbmc'" 
echo "         pas de connection SSH :$echo nc"
passwd xbmc
echo "***************************************************************"

echo "***************************************************************"
echo "* Nom de votre ordinateur source:/etc/hostname"
echo "***************************************************************"
echo "* Nom de la machine :"
read nomdupc
if [[ -z "$nomdupc" ]] ; then
    echo "ARCHBMC" > /etc/hostname
	nomdupc="ARCHBMC"
else
	echo $nomdupc > /etc/hostname
fi
echo ""

echo "***************************************************************"
echo "* Architecture (i386 - i686 - x86_64 - armv6l)"
echo "***************************************************************"
archi=`uname -m`
 if [ "$archi" = "armv6l" ]
 then
	echo "* Votre machine est elle un Raspbery Pi " ?
	echo -n "* Oui ? Non ? [Non] : "
	read rpi
	case $rpi in
		"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		archi=rpi;;
 
		*)
		echo ;;
	esac
fi
echo ""

echo "***************************************************************"
echo "* IP Fixe de l'ordinateur"
echo "***************************************************************"
export ip=192.168.1.77
ip="192.168.1.77"
echo "* Config DHCP :"
echo "* 	cp configuration/dhcpcd /etc/conf.d/"
echo "* 	systemctl enable dhcpcd@eth0.service"
echo "* Config IP FIXE"
echo "* Souhaitez-vous definir une adresse IP fixe ?"
echo -n "* Oui ? Non ? [Non] : "
read REP
case $REP in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
	echo "* Veuillez saisir l'adresse IP souhaité"
	read ip
	echo "* Veuillez saisir l'adresse du masque de sous reseau"
	read mask
	echo "* Veuillez saisir l'adresse de la passerelle par défaut"
    read gateway ;;
	*)
	echo ;;
esac
echo ""
echo "* Votre ip : "$ip
echo "interface=eth0" > /etc/conf.d/network
echo "address="$ip"" >> /etc/conf.d/network
echo "netmask=255.255.255.0" >> /etc/conf.d/network
echo "broadcast=192.168.1.255" >> /etc/conf.d/network
echo "gateway=192.168.1.1" >> /etc/conf.d/network
cp configuration/network.service /etc/systemd/system/
echo "* Config DNS [1:8.8.8.8 / 2:8.8.4.4]" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo ""

clear
export nomdupc=$nomdupc
echo "***************************************************************"
echo "* "
echo "* "
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
echo "* "
echo "* "
echo "***************************************************************"
echo ""

echo "***************************************************************"
echo "* Langue FR"
echo "***************************************************************"
# Config /etc/locale.gen
echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen
echo "fr_FR ISO-8859-1" >> /etc/locale.gen
echo "fr_FR@euro ISO-8859-15" >> /etc/locale.gen
# more /etc/locale.gen
locale-gen
echo "* /etc/locale.gen [OK]"
# Config /etc/locale.conf
touch /etc/locale.conf
echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf
echo "* /etc/locale.conf [OK]"
# Config /etc/vconsole.conf
touch /etc/vconsole.conf
# RPI
# echo "KEYMAP=fr-pc" >> /etc/vconsole.conf
# echo "FONT=" >> /etc/vconsole.conf
# echo "FONT_MAP=" >> /etc/vconsole.conf
# echo "* /etc/vconsole.conf [OK]"
# RPI
# Config /etc/localtime
# ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
# echo "* /etc/localtime [OK]"
# Configurez /etc/mkinitcpio.conf et créez les ramdisk avec 
mkinitcpio -p linux
echo "* mkinitcpio [OK]"
echo ""

echo "***************************************************************"
echo "* Configuration de syslinux (boot)"
echo "***************************************************************"
syslinux-install_update -iam
echo "* Syslinux [OK]"
echo ""

echo "***************************************************************"
echo "* Configuration de l'utilisateur ROOT"
echo "***************************************************************"
# Config /etc/vimrc
echo "set nu" >> /root/.vimrc
echo "syntaxe on" >> /root/.vimrc
echo "* syntaxe /root/.vimrc [OK]"
# Config /root/.bashrc
cp configuration/.bashrc /root/.bashrc
echo "* /root/.bashrc [OK]"
echo ""

echo "***************************************************************"
echo "* Configuration des sources"
echo "*    /etc/pacman.d/mirrorlist"
echo "*    /etc.pacman.conf"
echo "* Paquets libre et non libre + Yaourt"
echo "***************************************************************"
# RPI
#GREP A FAIRE
# sed -i 6i"## France" /etc/pacman.d/mirrorlist
# sed -i 7i'Server = http://mir.archlinux.fr/$repo/os/$arch' /etc/pacman.d/mirrorlist
# sed -i 8i"" /etc/pacman.d/mirrorlist
echo ""
# Ajout dépots
#sed -i 's/^SyncFirst   = pacman/SyncFirst = pacman yaourt package-query pacman-color pyalpm namcap/' /etc/pacman.conf
#sed -i 's/^#SigLevel = Optional TrustedOnly/SigLevel = Optional TrustedOnly/' /etc/pacman.conf
#echo '[multilib]' >> /etc/pacman.conf
#echo 'SigLevel = PackageRequired' >> /etc/pacman.conf
#echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
echo '' >> /etc/pacman.conf
echo "[archlinuxfr]" >> /etc/pacman.conf
echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf
if [ "$1" = "Game" ] ; then
    echo "Server = http://repo.archlinux.fr/x86_64" >> /etc/pacman.conf
else
    echo "Server = http://repo.archlinux.fr/i686" >> /etc/pacman.conf
fi
echo "* Ajout repo.archlinux.fr [OK]"
echo ""


echo "***************************************************************"
echo "* Installation des programmes basiques ..."
echo "***************************************************************"
pacman -Sy
echo "* Synchronisation [OK]"
pacman -Su --noconfirm subversion portaudio dbus-python python-cairo python2-cairo 
pacman -Su --noconfirm wget gstreamer0.10-base pcmanfm acpi acpid openssl pulseaudio pulseaudio-alsa alsa-plugins ntfs-3g nfs-utils
pacman -Su --noconfirm unrar p7zip lftp mtools dosfstools numlockx flac vorbis-tools links dbus xdg-user-dirs
echo "* Outils de base (1) [OK]"
pacman -Rsn --noconfirm initscripts sysvinit
pacman -Su --noconfirm systemd systemd-sysvcompat yaourt colordiff
# systemd-arch-units  pacman-color
echo "* Outils de base (2) [OK]"
pacman -Su --noconfirm xorg-fonts-type1 ttf-dejavu artwiz-fonts font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf ttf-bitstream-vera ttf-cheapskate ttf-liberation
echo "* Outils de base (3) - lissage des polices [OK]"
pacman -Su --noconfirm sshguard iptables
echo "* Outils de base (4) - Sécurité sshguard + iptables [OK]"
pacman -Su --noconfirm xorg-server xorg-xinit xorg-utils xorg-server-utils xterm
echo "* Outils de base (5) Xorg [OK]"
echo ""

echo "***************************************************************"
echo "* Configuration du réseau"
echo "* Utilisateur touriste sur /link/"
echo "* SAMBA /link/Partage"
echo "* SAMBA /link/Usb"
echo "* SAMBA /link/Usb2"
echo "* SAMBA /etc/samba/smb.conf <--Configuration"
echo "***************************************************************"
mkdir /link
mkdir /link/Partage
mkdir /link/Usb
mkdir /link/Usb2
chown -R touriste:users /link
cp configuration/.bashrc /home/touriste/.bashrc
chmod -R 750 /link
echo ""

echo "***************************************************************"
echo "* Configuration SSH "
echo "*  Port : 443 "
echo "*  Connection unique : touriste"
echo "*  Connection root : désactivé"
echo "*  Config /etc/ssh/sshd_config"
echo "***************************************************************"
cp configuration/sshd_config /etc/ssh/
echo ""

echo "***************************************************************"
echo "* Activation des services au démarrage ..."
echo "***************************************************************"
systemctl enable network.service
systemctl enable sshd.service
#systemctl enable dbus.service
systemctl enable acpid.service
systemctl enable smbd.service 
systemctl enable nmbd.service
echo ""

echo "***************************************************************"
echo "* Arch --> Installation Basique --> [Xbmc] --> Drivers --> Check "
echo "***************************************************************"
sh archbox_2xbmc.sh
