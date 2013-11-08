echo -e "$white * Mise à jour arch ..."
echo -e " * $cyan"
pacman -Sy
pacman -Suy --noconfirm
echo -e "$white * Mise à jour$yellow [OK]"