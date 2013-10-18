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
		"log")
			echo -e "$yellow Attention il existe déjà un fichier log ($2)"
			echo -e "$yellow pour ce script est vous sur de vouloir continuer ? $red"
			read -p " Appuyer sur une touche pour continuer (sinon quitter)..." ;; 
		*)
			echo "" ;;
	esac
fi
	
###############################################################################################