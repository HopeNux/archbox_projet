#!/bin/sh
###############################################
# [ARCHBOX]
###############################################
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if $xbmc; then
   echo "Chargement de XBMC en cours..."
   exec startx /usr/bin/xbmc-standalone &> /dev/null
elif $xfce; then
   echo "Chargement du bureau (Xfce) en cours..."
   exec startxfce4 &> /dev/null
elif $emu; then
   "Chargement de l'émulateur en cours..."
   exec /usr/bin/qmc2 &> /dev/null
fi