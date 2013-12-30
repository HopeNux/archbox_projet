echo "Installer les dépot amd dans les dépots pacman.conf avant d'installer xorg"
#!/bin/sh
clear

echo "***************************************************************"
echo "* Bienvenue dans l'aide de l'installation ARCHLINUX"
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
mkfs.ext4 /dev/sda1
echo "* Formatage ext3 de sda1 en boot [OK]"
mkfs.ext4 /dev/sda3
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
pacstrap /mnt base-devel syslinux net-tools openssh linux-headers
echo "* Installation du paquet BASE-DEVEL et SYSLINUX [OK]"
echo " genfstab -U = fstab par UUID"
genfstab -U -p /mnt >> /mnt/etc/fstab
echo "* Génération du fstab sur /mnt/etc/fstab [OK]"
echo "arch-chroot /mnt"
echo "Configurez /etc/mkinitcpio.conf et créez les ramdisk avec "
echo " mkinitcpio -p linux"
echo " syslinux-install_update -iam"
echo "ATTENTION SYSLINUX SUR SDA3"
echo "GRUB"
echo "#grub-install --no-floppy --recheck /dev/sda"
echo "#grub-mkconfig -o /boot/grub/grub.cfg"
echo "Detection WINDOWS OS : pacman -S os-prober"
echo "Modification grub : nano /boot/grub/grub.cfg"
echo "## fi"