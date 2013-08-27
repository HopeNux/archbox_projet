#!/bin/sh
clear
echo "***************************************************************"
echo "*# 														   #*"
echo "*# [ ARCHBOX ]											   #*"
echo "*# Votre console multimédia de salon 						   #*"
echo "*# 														   #*"
echo "***************************************************************"
echo ""
pacman -Su --noconfirm xfce4 xfce4-goodies
pacman -Su --noconfirm xfce4-panel xfconf xfce4-clipman-plugin orage xfce4-wavelan-plugin xfce4-mixer gstreamer0.10-base-plugins faenza-icon-theme elementary-gtk-theme

