# archbox_projet

Principe :

    L’installation ce présente sous formes de scripts, utilisant les dépôts officiels et 
    communautaires (AUR), les scripts pourront être lancés indépendamment les un des autres,
    ou exécuté à la suite par un script de configuration.

    L’installation peut être exécutée sur un système Archlinux préalablement installé 
    ou sur une nouvelle installation (après avoir configurer les partitions, le réseau
    et le chargeur d’amorçage).

    Une fois l’installation correctement effectuée, L’ordinateur démarrera sur un menu 
    de sélection qui vous proposera (suivant les installations effectué précédemment) 
    de démarrer sur XBMC, une interface graphique standard (XFCE) ou un gestionnaire 
    d’émulateur (si l'utilisateur ne fait rien, XBMC se lancera par défaut).


Les options :

    Cette Ordinateur pourra être utilisé comme serveur multimédia pour stocker sur le
    réseau vos films musique images. Je souhaite également y intégré des mini jeux 
    par des émulateurs (nintendo, sega,...) relié par une manette pour plus de 
    convivialité, y intégré un service SSH et pourquoi pas VPN pour envisager 
    du streaming ou jeux à distance entre amis.
    

## archbox_1config.sh


    Script pour gérer le réseau, partage, langues, démarrage, programmes basique
    (audio,xorg,ssh,...) tout cela par défaut. [OK]
    [OK] : Partage réseau samba (Dossiers par défaut : partage / usb / usb2 /
    littlemovies(a racorder sur un disque dur) / bigmovies(a racorder sur un disque dur)) [HopeNux]
    [OK] : Connection SSH + Auto PROXY [HopeNux]
    [RAF] : Création d'une version multilingue (voir AUI)
    Optimisation du script (+ cat)
    Partage réseau revu [HopeNux]
    Installation audio revu [DOcGui]
    Ajout d'un utilisateur personnalisé (autre que xbmc). [HopeNux]
    Copies des thèmes [Xorg] avant l'installation des fonctionnalités de montage de disque dur etc.
    


## archbox_2xbmc.sh


    Script d'installation du logiciel XBMC
    [OK] : Optimisation du logiciel XBMC pour le RPI (Gotham version)
    Optimisation du script (+ cat)
    Prise en compte du nouvel utilisateur [HopeNux]



## archbox_3desktop.sh


    Script d'installation d'un bureau basé sur xfce avec un thème par défaut.
    [OK] : Ajout d'un shell avec installation d'un thème personnalisé [Xorg]
    [OK] : Installation de l'interface Xfce avec logiciels de base (gparted, filezilla, 
    connexion (wifi),...) [HopeNux, DOcGui]
    Optimisation du script (+ cat)
    Prise en compte du nouvel utilisateur (création des répertoires en adéquation 
    avec le logiciel xbmc) [HopeNux]
    Nouveau thème [NUMIX]
    Gestion de l'accès réseau par gvfs via thunar
    Gestion de l'accès aux smartphone via thunar
    Gestion des archives (7zip + autres)
    Lecteurs de PDF (mupdf + firestarter)
    Calculatrice + Paint + Gestionnaire d'images
    Lecteurs multimédias (kaffeine fr + vlc)
    Interface pour parfeu (firestarter)
    Navigateurs (chromium fr + lecteur de flash [libre] + mozilla fr)
    Firmware pour résolution de bugs (brocade-firmware/aic94xx-firmware) + non obligatoire (siano-tv-fw).



## archbox_4emulateur.sh


    Script d'installation d'émulateurs.
    [EN COUR] : Etude sur l'émulateur M.A.M.E / SNESX / N64 .
    Optimisation du script



## archbox_5drivers.sh


    Script uniquement d'indiquation pour installer le bon drivers vidéo.
    [RAF] : Installation automatique des drivers du RPI (ok pour la vidéo) [HopeNux, DOcGui]
    Optimisation du script



## archbox_6boot.sh


    Script intégrant quelques configurations et un script de démarrage (ARCHBOXBOOT).
    [OK] : Configurration Ip fixe ou dhcp + DNS
    [OK] : Démarrage automatique (autologin, upower, devmon)
    [OK] : ARCHBOXBOOT --> Compatible télécommande
    A.1) Choix [1:XBMC 2:Desktop (xfce) 3:Emulateur 4:Eteindre]
    A.2) Lorsque 1 ou 2 ou 3 est fermé retour à l'interface de démarrage.
    Optimisation du script (+ cat)
    Prise en compte du nouvel utilisateur (autologin + lancement auto de archboxboot) [HopeNux]
    Démarrage du RPI pris en compte (getty.service)



## SOUS REPERTOIRE :


archbox-boot (archboxboot) [contribution HopeNux, Xorg, DOcGui]

    service archbox (utile si la personne ne souhaite pas d'interface de lancement)
    autologin
    démarrage et conf SSH + Proxy
    archboxboot (interface de démarrage avec sélection)


archbox-network [contribution HopeNux]

    service ip fixe
    dns par défaut
    configuration samba


archbox-theme [contribution Xorg, HopeNux(MAJ)]

    thème xfce avec barre + config par defaut


archbox-opt [contribution HopeNux]

    script github download
    script mise à jour arch
    script gestion des erreurs
    script memo installation rapide de arch (bootstrap...)

archbox-img [contribution de n3os]

