echo -e "Mise à jour arch ...$cyan"
pacman -Syy
pacman -Suy --noconfirm
echo -e "$white$ok Mise à jour"