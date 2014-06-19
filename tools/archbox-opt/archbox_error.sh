#!/bin/bash
###############################################################################################
#----------------------------------------------------------------
# Gestion d'erreurs
#----------------------------------------------------------------
if [ -s $2 ] ; then
	case $1 in
		"lck")
			#----------------------------------------------------------------
			# Gestion de la présence des locks
			#----------------------------------------------------------------
			echo -e "$yellow Attention un fichier lock existe déjà pour le script archbox_($2)"			
			echo -e "$yellow Si vous souhaitez encore executer se script activer le mod debug !"
			echo -e "$yellow est vous sur de vouloir continuer ? $red"
			read -p "Appuyer sur une touche pour continuer (sinon quitter [CTRL+C])..." ;; 
		"autre")
			#----------------------------------------------------------------
			# Gestion de ...
			#----------------------------------------------------------------
			echo "$red" ;; 
		*)
			echo "$red" ;;
	esac
fi
###############################################################################################
