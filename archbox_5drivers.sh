#!/bin/bash
################################################################################################################
#------------------------------------------------------------------------------------------------------
# ARCHBOX_6BOOT.SH --> DEBUT
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
echo -e "$green * [$red ARCHBOX$green ]"									   				  
echo -e "$green * Votre console multimedia de salon" 
echo -e "$green * Installation $yellow [BOOT]$cyan [En cour...]"
echo -e "$green * "
echo -e "$green ******************************************************************************"
echo " "

################################################################################################################


################################################################################################################
#------------------------------------------------------------------------------------------------------
# Vérification fichier lck
#------------------------------------------------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "lck" "$rep/6boot.lck"
if [ -f "$rep/6boot.lck" ] ; then
	rm $rep/6boot.lck
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
echo -e "Reglage de la carte reseau... $cyan"
ifconfig -a | more

echo -e "$red"
read -p "Veuillez saisir le nom de votre carte réseau (eth0) : " cartereseau
read -p "Souhaitez-vous definir une adresse IP fixe  Oui ? Non ? [Non] : " REP

case $REP in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")

		read -p "Adresse IP souhaité : " ip
		read -p "Adresse du masque de sous réseau (defaut : 255.255.255.0) " mask
		read -p "Adresse de la passerelle par défaut : " gateway

		if [ -z "$mask" ] ; then
			mask="255.255.255.0"
		fi	
		
		export ip=$ip
		echo "Votre ip : "$ip
		echo "interface="$cartereseau"" > /etc/conf.d/network
		echo "address="$ip"" >> /etc/conf.d/network
		echo "netmask="$mask"" >> /etc/conf.d/network
		echo "broadcast=192.168.1.255" >> /etc/conf.d/network
		echo "gateway="$gateway"" >> /etc/conf.d/network	

		systemctl disable dhcpcd.service
		systemctl disable dhcpcd@$cartereseau.service
		systemctl enable network.service 

		echo -e "$white$ok Configuration ip fixe";;
	*)		
		if [ -z "$cartereseau" ] ; then
			systemctl enable dhcpcd.service			
		else
			systemctl enable dhcpcd@$cartereseau.service
		fi
		echo -e "$white$ok Configuration dhcpd";;
esac

cp $rep/tools/archbox-network/network.service /etc/systemd/system/

echo "# ARCHBOX " > /etc/resolv.conf
echo "# Configuration DNS [1-8.8.8.8 / 2-8.8.4.4]" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "nameserver "$gateway"" >> /etc/resolv.conf

echo -e "$white$ok Configuration réseau & dns"

#------------------------------------------------------------------------------------------------------
# Config /etc/netctl (par defaut)
#------------------------------------------------------------------------------------------------------
echo -e "Configuration par defaut de netctl"
cho -e "$white$ok Configuration netctl"

################################################################################################################


################################################################################################################
if [ "$archi" == "rpi" ] ; then
	ln -s /usr/lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/serial-getty@ttyAMA0.service
fi

#------------------------------------------------------------------------------------------------------
# Install autologin
#------------------------------------------------------------------------------------------------------
echo -e "Installation de l'autologin sur $user"
echo -e "Copie /usr/lib/systemd/system/autologin.service"
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
Environment=LANG= LANGUAGE= LC_CTYPE= LC_NUMERIC= LC_TIME= LC_COLLATE= LC_MONETARY= LC_MESSAGES= LC_PAPER= LC_NAME= LC_ADDRESS= LC_TELEPHONE= LC_MEASUREMENT= LC_IDENTIFICATION=

# Some login implementations ignore SIGTERM, so we send SIGHUP
# instead, to ensure that login terminates cleanly.
KillSignal=SIGHUP

[Install]
Alias=getty.target.wants/getty@tty1.service
EOF
cp $rep/tools/archbox-boot/autologin@.service /usr/lib/systemd/system/getty@.service
cp $rep/tools/archbox-boot/autologin@.service /etc/systemd/system/
cho -e "$white$ok Autologin sur $user"

#------------------------------------------------------------------------------------------------------
# Install archboxboot
#------------------------------------------------------------------------------------------------------
echo -e "Copie /usr/bin/archboxboot ..."
cp $rep/tools/archbox-boot/archboxboot /usr/bin/
chmod 755 /usr/bin/archboxboot
echo -e "Copie /etc/systemd/system/archbox.service ..."
cp $rep/tools/archbox-boot/archbox@.service /etc/systemd/system/
echo -e "$white$ok ARCHBOX Service (voir /usr/bin/archboxboot pour le script de lancement) "

#------------------------------------------------------------------------------------------------------
# Config xinitrc
#------------------------------------------------------------------------------------------------------
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
echo -e "$white$ok Config .xinitrc "

#------------------------------------------------------------------------------------------------------
# Config bash_profile
#------------------------------------------------------------------------------------------------------
if [ -f "$HOME/.bash_profile" ] ; then
	rm $HOME/.bash_profile
fi
cat <<EOF >$HOME/.bash_profile
# ~/.bash_profile
#
#[[ -f ~/.bashrc ]] && . ~/.bashrc
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
EOF
echo "sh /usr/bin/archboxboot" >> /home/$user/.bash_profile
echo -e "$white$ok Config .bash_profile (ajout de script archboxboot au demarrage) "

#------------------------------------------------------------------------------------------------------
# Config xsession
#------------------------------------------------------------------------------------------------------
if [ -f "$HOME/.xsession" ] ; then
	rm $HOME/.xsession
fi
cat <<EOF >$HOME/.xsession
#!/bin/sh
# ~/.xsession
# Executed by xdm/gdm/kdm at login
/bin/bash --login -i ~/.xinitrc
EOF
echo -e "$white$ok Config .xsession  "

#------------------------------------------------------------------------------------------------------
# Services au demarrage
#------------------------------------------------------------------------------------------------------
echo -e "Activation des services au démarrage ..."
# systemctl enable archbox@xbmc.service <-- PAS DE ARCHBOXBOOT
systemctl enable upower
systemctl disable getty@tty1
systemctl daemon-reload
systemctl enable autologin@$user.service
systemctl enable multi-user.target
systemctl enable devmon@$user
if [ "$archi" == "rpi" ] ; then
	systemctl enable getty@ttyAMA0.service	
fi
echo -e "$white$ok Activation des services"

cat <<EOF > $rep/6boot.lck
#----------------------------
# ARCHBOX_6BOOT.SH --> [OK]
#----------------------------
EOF
################################################################################################################


################################################################################################################
echo -e "$green **********************************************************************************************************"
echo -e "$green * "
echo -e "$green * [$red ARCHBOX$green ]"			
echo -e "$green * Installation $yellow [BOOT]$red Terminé"						   				  
echo -e "$green * "
echo -e "$red * Attention si ce n'ai pas déjà fait ajouter manuellement 'bna' dans $MODULES "
echo -e "$red * sur /etc/mkinitcpio.conf et recharger mkinitcpio avec ==> mkinitcpio -p linux"
echo -e "$green ********************************************************************************************************** $nc"
################################################################################################################
