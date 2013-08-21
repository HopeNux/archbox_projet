#!/bin/sh
clear
echo "***************************************************************"
echo "* Bienvenue dans l'installation d'ARCH LINUX"
echo "***************************************************************"
echo "***************************************************************"
echo "* [Arch] --> Installation Basic --> Drivers --> Xbmc --> Check "
echo "***************************************************************"
loadkeys fr-pc
echo "* Clavier français [OK]"
systemctl start sshd
echo "* SSH  (port 22) [OK]"
echo "* IP réseau local : "
ifconfig
echo "* Si aucune IP taper : systemctl start dhcpcd.service"
echo "* Mot de passe ROOT : "
passwd
echo ""

echo "***************************************************************"
echo "* Partionnement du disque dur (sdaX)"
echo "***************************************************************"
fdisk -l
mkfs.ext3 /dev/sda1
echo "* Formatage ext3 de sda1 en boot [OK]"
mkfs.ext3 /dev/sda3
echo "* Formatage ext3 de sda3 en racine [OK]"
mkswap /dev/sda2
echo "* Formatage swap de sda2 en swap [OK]"
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
echo "* Montage des partitions [OK]"
echo ""

echo "***************************************************************"
echo "* Installation de ARCH"
echo "***************************************************************"
pacstrap /mnt base 
echo "* Installation du paquet BASE [OK]"
pacstrap /mnt base-devel syslinux
echo "* Installation du paquet BASE-DEVEL et SYSLINUX [OK]"
genfstab -U -p /mnt >> /mnt/etc/fstab
echo "* Génération du fstab sur /mnt/etc/fstab [OK]"
echo ""

echo "***************************************************************"
echo "* Arch --> [Installation Basic] --> Drivers --> Xbmc --> Check "
echo "* Installation Effectuée, lancer le script _basic_install.sh"
echo "***************************************************************"
echo ""
arch-chroot /mnt