#!/bin/sh
clear
echo "***************************************************************"
echo "*# 														   #*"
echo "*# [ ARCHBOX ]											   #*"
echo "*# Votre console multimédia de salon 						   #*"
echo "*# 														   #*"
echo "***************************************************************"
echo ""
echo "***************************************************************"
echo "* Vérification des configurations en manuel"
echo "***************************************************************"
# Vérification bon sda
echo "Vérifier si le fichier syslinux.cfg comporte bien le sdaX de la racine"
echo "	Affichage des partitions : fdisk -l"
echo "	Configuration : more /boot/syslinux/syslinux.cfg"
echo "	Mise à jour si modification : syslinux-install_update -iam"
echo ""

# Vérification de l'ip fixe 
echo "Vérifier si le fichier network possède bien la bonne carte réseau (eth ou autre)"
echo "	Vérifier également l'ip : ifconfig"
echo "	Configuration : more /etc/conf.d/network"
echo ""

# Vérification de la langue
echo "Vérifier si le fichier locale.gen possède bien la bonne langue et non autre"
echo "Si anglais, laisser car peut servire pour des programmes natifs en anglais"
echo "	more /etc/locale.gen"
echo "	régénérer le locale : locale-gen"
echo ""

# Vérification du partage réseau
echo "Configuration SAMBA : nano /etc/samba/smb.conf"
echo ""

# Vérification de l'arret sur XBMC
echo "Vérifier les règles de fermetures de xbmc (syntaxe)"
echo "nano /etc/polkit-1/rules.d/10-xbmc.rules"

# RPI
echo "KEYMAP=fr-pc" >> /etc/vconsole.conf
echo "FONT=" >> /etc/vconsole.conf
echo "FONT_MAP=" >> /etc/vconsole.conf
echo "* /etc/vconsole.conf [OK]"
# RPI
# Config /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime