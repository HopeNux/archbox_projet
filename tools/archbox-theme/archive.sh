#!/usr/bin/sh

tar -cJvf archbox-theme.tar.xz \
archbox \
xfce4 \
bashrc \
gtkrc-2.0

updpkgsums
rm -rf src