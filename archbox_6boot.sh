#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# ARCHBOX_6BOOT.SH --> DEBUT
#----------------------------------------------------------------
rep=`(cd $(dirname "$0"); pwd)`
user="xbmc"

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
export ip="192.168.1.44"

#----------------------------------------------------------------
# Vérification / Creation fichier LOG
#----------------------------------------------------------------
sh $rep/tools/archbox-opt/archbox_error.sh "log" "$rep/archbox_6boot.log"
echo "" > $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "# ARCHBOX_5DRIVERS.SH --> DEBUT" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
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
###############################################################################################

echo " "
echo " "

###############################################################################################
sh $rep/tools/archbox-opt/archbox_maj.sh
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
echo -e "$white * IP Fixe de l'ordinateur $cyan"
ifconfig -a | more
echo -e " * $red" 
read -p " * Veuillez saisir le nom de votre carte réseau (eth0) : " cartereseau
read -p " * Souhaitez-vous definir une adresse IP fixe  Oui ? Non ? [Non] : " REP
case $REP in
	"o"|"oui"|"O"|"Oui"|"OUI"|"y"|"yes"|"Y"|"Yes"|"YES")
		read -p " * Adresse IP souhaité : " ip
		read -p " * Adresse du masque de sous réseau : " mask
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
		systemctl disable dhcpcd@$cartereseau.service
		systemctl enable network.service ;;
	*)		
		if [ "$cartereseau" ] ; then
			systemctl enable dhcpcd@$cartereseau.service
		else
			systemctl enable dhcpcd.service
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
echo -e "$white * Vérification des configurations en manuel"
echo -e "$white * Génération du log sur les vérifications à effectuer ..."
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "# Vérification des configurations en manuel " >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérification démarrage sur syslinux" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérifier si le fichier syslinux.cfg comporte bien le sdaX de la racine" >> $rep/archbox_6boot.log
echo "Affichage des partitions : fdisk -l" >> $rep/archbox_6boot.log
echo "Configuration : /boot/syslinux/syslinux.cfg" >> $rep/archbox_6boot.log
echo "Commande de mise à jour si modification : syslinux-install_update -iam" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérification de l'ip fixe" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérifier si le fichier network possède bien la bonne carte réseau (eth ou autre)" >> $rep/archbox_6boot.log
echo "Vérifier également l'ip : ifconfig" >> $rep/archbox_6boot.log
echo "Configuration IP : /etc/conf.d/network" >> $rep/archbox_6boot.log
echo "Configuration DNS : /etc/resolv.conf" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérification de la langue" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérifier si le fichier locale.gen possède bien la bonne langue et non autre" >> $rep/archbox_6boot.log
echo "Si anglais, laisser car peut servire pour des programmes natifs en anglais" >> $rep/archbox_6boot.log
echo "Configuration langue : /etc/locale.gen" >> $rep/archbox_6boot.log
echo "Générer le locale : locale-gen" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérification du partage réseau" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Configuration SAMBA : /etc/samba/smb.conf" >> $rep/archbox_6boot.log
echo "Utilisateur SAMBA : touriste" >> $rep/archbox_6boot.log
echo "Dossier SAMBA : /link/Partage" >> $rep/archbox_6boot.log
echo "Dossier SAMBA : /link/Usb" >> $rep/archbox_6boot.log
echo "Dossier SAMBA : /link/Usb2" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérification de l'arret sur XBMC" >> $rep/archbox_6boot.log
echo "#----------------------------------------------------------------" >> $rep/archbox_6boot.log
echo "Vérifier les règles de fermetures de xbmc (syntaxe)" >> $rep/archbox_6boot.log
echo "Fichier : /etc/polkit-1/rules.d/10-xbmc.rules" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo "" >> $rep/archbox_6boot.log
echo -e "$white * LOGS générés$yellow [OK]"
echo -e "$white ******************************************************************************"
###############################################################################################

echo " "
echo " "

###############################################################################################
echo -e "$white ******************************************************************************"
# RPI ln -s /usr/lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/serial-getty@ttyAMA0.service
echo -e "$white * Copie /etc/systemd/system/archbox.service"
cp $rep/tools/archbox-boot/archbox@.service /lib/systemd/system/
echo -e "$white * Copie /usr/lib/systemd/system/autologin.service"
cp $rep/tools/archbox-boot/autologin@.service /usr/lib/systemd/system/getty@.service
cp $rep/tools/archbox-boot/autologin@.service /lib/systemd/system/
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
# PAS DE ARCHBOXBOOT --> systemctl enable archbox@xbmc.service
systemctl enable autologin@$user.service
systemctl enable multi-user.target
systemctl enable devmon@$user
# RPI systemctl enable getty@ttyAMA0.service	
echo "exec /usr/bin/archboxboot" >> /home/xbmc/.bash_profile
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
echo -e "$green ******************************************************************************"
###############################################################################################
