#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_6BOOT.SH --> DEBUT
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
export ip="192.168.1.44"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [BOOT]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo -e "$green * "
#----------------------------------------------------------------
# Vérification fichier lck
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/6boot.lck"
if [ -f "$rep/6boot.lck" ] ; then
	rm $rep/6boot.lck
fi

#----------------------------------------------------------------
# Mise à jour + Installation
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_maj.sh
echo -e "$green * "
echo -e "$green ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * IP Fixe de l'ordinateur $cyan"
#----------------------------------------------------------------
# Nouveau utilisateur
#----------------------------------------------------------------
if [ -z "$1" ] ; then
	read -p " * (2) Nouveau utilisateur : (défaut xbmc) " user
	if [ -z "$user" ] ; then
		user="xbmc"
	fi
else
	user="$1"
fi
export HOME="/home/$user"

#----------------------------------------------------------------
# Architecture (i386 - i686 - x86_64 - armv6l)
#----------------------------------------------------------------
if [ -z "$2" ] ; then
	archi=`uname -m`
	echo -e "$green * Votre architecture$yellow $archi"
	if [ "$archi" = "armv6l" ] ; then
		echo -e " * $red"
		read -p " * Votre machine est elle un Raspberry Pi Oui ? Non ? [def:Non] : " rpi
		case $rpi in
			"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
				archi="rpi" ;; 
			*)
				echo "$green * " ;;
		esac
	fi
else
	echo -e "$white * Architecture $2"
fi

ifconfig -a | more
echo -e " * $red" 
read -p " * Veuillez saisir le nom de votre carte réseau (eth0) : " cartereseau
read -p " * Souhaitez-vous definir une adresse IP fixe  Oui ? Non ? [Non] : " REP
case $REP in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		read -p " * Adresse IP souhaité : " ip
		read -p " * Adresse du masque de sous réseau (defaut : 255.255.255.0) " mask
		if [ -z "$mask" ] ; then
			mask="255.255.255.0"
		fi
		read -p " * Adresse de la passerelle par défaut : " gateway		
		export ip=$ip
		echo "$white * Votre ip : "$ip
		echo "interface="$cartereseau"" > /etc/conf.d/network
		echo "address="$ip"" >> /etc/conf.d/network
		echo "netmask="$mask"" >> /etc/conf.d/network
		echo "broadcast=192.168.1.255" >> /etc/conf.d/network
		echo "gateway="$gateway"" >> /etc/conf.d/network
		cp $rep/tools/archbox-network/network.service /etc/systemd/system/	
		echo -e "$white * Configuration ip fixe$yellow [OK] $white"
		systemctl disable dhcpcd.service
		systemctl disable dhcpcd@$cartereseau.service
		systemctl enable network.service ;;
	*)		
		if [ -z "$cartereseau" ] ; then
			systemctl enable dhcpcd.service			
		else
			systemctl enable dhcpcd@$cartereseau.service
		fi
		echo -e "$white * Configuration dhcpd$yellow [OK] $white";;
esac
echo "# ARCHBOX " > /etc/resolv.conf
echo "# Configuration DNS [1-8.8.8.8 / 2-8.8.4.4]" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "nameserver "$gateway"" >> /etc/resolv.conf
echo -e "$white * Configuration réseau$yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
if [ "$archi" == "rpi" ] ; then
	ln -s /usr/lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/serial-getty@ttyAMA0.service
fi
echo -e "$white * Copie /etc/systemd/system/archbox.service"
cp $rep/tools/archbox-boot/archbox@.service /etc/systemd/system/
echo -e "$white * Copie /usr/lib/systemd/system/autologin.service"
if [ -f "$rep/tools/archbox-boot/autologin@.service" ] ; then
	rm $rep/tools/archbox-boot/autologin@.service
fi
cat <<EOF > $rep/tools/archbox-boot/autologin@.service
[Unit]
Description=Getty on %I
Documentation=man:agetty(8) man:systemd-getty-generator(8)
Documentation=http://0pointer.de/blog/projects/serial-console.html
After=systemd-user-sessions.service plymouth-quit-wait.service

# If additional gettys are spawned during boot then we should make
# sure that this is synchronized before getty.target, even though
# getty.target didn't actually pull it in.
Before=getty.target
IgnoreOnIsolate=yes

# On systems without virtual consoles, don't start any getty. (Note
# that serial gettys are covered by serial-getty@.service, not this
# unit
ConditionPathExists=/dev/tty0

[Service]
# the VT is cleared by TTYVTDisallocate
ExecStart=-/sbin/agetty --noclear -a $user %I 38400 linux
Type=idle
Restart=always
RestartSec=0
UtmpIdentifier=%I
TTYPath=/dev/%I
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
KillMode=process
IgnoreSIGPIPE=no

# Unset locale for the console getty since the console has problems
# displaying some internationalized messages.
Environment=LANG= LANGUAGE= LC_CTYPE= LC_NUMERIC= LC_TIME= LC_COLLATE= LC_MONETARY= LC_MESSAGES= LC_P
APER= LC_NAME= LC_ADDRESS= LC_TELEPHONE= LC_MEASUREMENT= LC_IDENTIFICATION=

# Some login implementations ignore SIGTERM, so we send SIGHUP
# instead, to ensure that login terminates cleanly.
KillSignal=SIGHUP

[Install]
Alias=getty.target.wants/getty@tty1.service
EOF
cp $rep/tools/archbox-boot/autologin@.service /usr/lib/systemd/system/getty@.service
cp $rep/tools/archbox-boot/autologin@.service /lib/systemd/system/
cp $rep/tools/archbox-boot/autologin@.service /etc/systemd/system/
echo -e "$white * Copie /usr/bin/archboxboot"
cp $rep/tools/archbox-boot/archboxboot /usr/bin/
chmod 755 /usr/bin/archboxboot
echo -e "$white * ARCHBOX Service$yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * Activation des services au démarrage ..."
systemctl enable upower
systemctl disable getty@tty1
systemctl daemon-reload
# systemctl enable archbox@xbmc.service <-- PAS DE ARCHBOXBOOT
systemctl enable autologin@$user.service
systemctl enable multi-user.target
systemctl enable devmon@$user
if [ "$archi" == "rpi" ] ; then
	systemctl enable getty@ttyAMA0.service	
fi
echo "exec /usr/bin/archboxboot" >> /home/$user/.bash_profile
echo -e "$white * Activation des services $yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_6BOOT.SH --> FIN
#----------------------------------------------------------------
echo -e "$green ******************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"			
echo -e "$green * Installation $yellow [BOOT]$red Terminé"						   				  
echo -e "$green * "
echo -e "$red * Attention si ce n'ai pas déjà fait ajouter manuellement 'bna' dans $MODULES "
echo -e "$red * sur /etc/mkinitcpio.conf et recharger mkinitcpio avec ==> mkinitcpio -p linux"
echo -e "$green ****************************************************************************** $nc"
cat <<EOF > $rep/6boot.lck
#----------------------------------------------------------------
# ARCHBOX_6BOOT.SH --> [OK]
#----------------------------------------------------------------
EOF
###############################################################################################
