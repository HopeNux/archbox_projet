#!/bin/sh
clear
echo "***************************************************************"
echo "*# 														   #*"
echo "*# [ ARCHBOX ]											   #*"
echo "*# Votre console multimédia de salon 						   #*"
echo "*# 														   #*"
echo "***************************************************************"
echo ""
pacman -Su --noconfirm xfce4 xfce4-goodies gstreamer0.10-base-plugins faenza-icon-theme
yaourt -S --noconfirm elementary-gtk-theme
cp -Rv "tools/archbox-theme/xfce4/" "/home/xbmc/.config/"
cp -Rv "tools/archbox-theme/archbox/" "/usr/share/"
cp -v "tools/archbox-theme/bashrc" "/home/xbmc/.bashrc"
cp -v "tools/archbox-theme/gtkrc-2.0" "/home/xbmc/.gtkrc-2.0"
chown -Rv xbmc:xbmc /home/xbmc
