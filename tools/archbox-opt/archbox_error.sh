#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# Gestion d'erreurs
#----------------------------------------------------------------


#----------------------------------------------------------------
# Gestion de la présence des logs
#----------------------------------------------------------------
if [ -s $2 ] ; then
	case $1 in
		"lck")
			echo -e "$yellow Attention un fichier lock existe déjà pour le script archbox_($2)"
			echo -e "$yellow est vous sur de vouloir continuer ? $red"
			read -p " Appuyer sur une touche pour continuer (sinon quitter)..." ;; 
		*)
			echo "" ;;
	esac
fi
	
###############################################################################################