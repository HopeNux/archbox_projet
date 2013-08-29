#!/bin/sh
clear
echo "***************************************************************"
echo "*# 														   #*"
echo "*# [ ARCHBOX ]											   #*"
echo "*# Votre console multimédia de salon 						   #*"
echo "*# 														   #*"
echo "***************************************************************"
echo ""
pacman -Su --noconfirm xfce4 xfce4-goodies gstreamer0.10-base-plugins faenza-icon-theme elementary-gtk-theme wget
mkdir /tmp/archbox && cd /tmp/archbox && wget https://raw.github.com/HopeNux/archbox_projet/master/tools/archbox-theme/PKGBUILD && wget https://raw.github.com/HopeNux/archbox_projet/master/tools/archbox-theme/archbox-theme.tar.xz && makepkg -si