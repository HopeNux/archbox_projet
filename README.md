# archbox_projet

Principe :

    L’installation ce présente sous formes de scripts, utilisant les dépôts officiels et 
    communautaires (AUR), les scripts pourront être lancés indépendamments les un des autres,
    ou exécutés à la suite par un script de configuration.

    Attention : L’installation doit être exécutée sur un système Archlinux préalablement installé 
    ou sur une nouvelle installation (après la configuration des partitions, du réseau
    et du chargeur d’amorçage).

    Une fois l’installation "archbox" effectuée, L’ordinateur démarrera sur un "menu"
    de sélection qui vous proposera de démarrer sur differentes platformes :
    1 - [XBMC]
    2 - [XFCE ou LXDE(pour le raspberry pi)]
    3 - [Steam (interface console)]
    4 - [Emulateur (Super Nintendo, N64, MegaDrive)]
    5 - [Terminal]
    6 - [Eteindre votre ordinateur]
    
    Toutes les selections sont compatibles avec une telecommande.


Les options :

    Serveur Multimedia (stockage de films, series, clips, musiques, ...) - [Disponible]
    Bureau classique avec XFCE ou LXDE et une interface base sur "Numix"  - [Disponible]
    Emulateurs (Super Nintendo, N64, MegaDrive)  - [SuperNintendo Disponible]
    Steam - [En cour de tests...]
    Autres : SSH, Partage reseau, SFTP, Drivers manette XBOX, telecommande IR...
    

## archbox_1config.sh


    #### Script pour gérer le réseau, langues, démarrage, programmes basique (xorg,ssh,...)
    
    [OK] : Partage réseau samba (Dossiers par défaut : partage / usb [HopeNux]
    [OK] : Connection SSH + Auto PROXY [HopeNux]
    [OK] : Optimisation du script (+ cat + design).
    [OK] : Partage réseau revu [HopeNux]
    [OK] : Installation audio revu (PulseAudio) [DOcGui]
    [OK] : Ajout d'un utilisateur personnalisé (autre que xbmc). [HopeNux]
    [RAF] : Création d'une version multilingue (voir AUI).
    Copies des thèmes [Xorg] avant l'installation des fonctionnalités de montage de disque dur etc.
    

## archbox_2xbmc.sh


    #### Script d'installation du logiciel XBMC
    
    [OK] : Optimisation du logiciel XBMC pour le RPI (Gotham version 13).
    [OK] : Optimisation du script (+ cat + design).
    [OK] : Prise en compte du nouvel utilisateur [HopeNux]


## archbox_3desktop.sh


    #### Script d'installation d'un bureau basé sur xfce avec un thème par défaut.
    
    [OK] : Ajout d'un shell avec installation d'un thème personnalisé [Xorg]
    [OK] : Installation de logiciels de base (gparted, filezilla,...) [HopeNux, DOcGui]
    [OK] : Optimisation du script (+ cat + design)
    [OK] : Prise en compte du nouvel utilisateur [HopeNux]
    [OK] : Nouveau thème [NUMIX]
    [OK] : Gestion de l'accès réseau par gvfs via thunar
    [OK] : Gestion de l'accès aux smartphone via thunar
    [OK] : Gestion des archives (7zip + autres)
    [OK] : Lecteurs de PDF (mupdf + firestarter)
    [OK] : Calculatrice + Paint + Gestionnaire d'images
    [OK] : Lecteurs multimédias (kaffeine fr + vlc)
    [OK] : Interface pour parfeu (firestarter)
    [OK] : Navigateurs (firefox fr + lecteur de flash [libre])
    [OK] : Firmware (brocade-firmware/aic94xx-firmware) + (siano-tv-fw).


## archbox_4emulateur.sh


    #### Script d'installation d'émulateurs + Steam.
    
    [EN COUR] : Etude sur l'émulateur M.A.M.E / N64 / MegaDrive.
    [OK] : Optimisation du script (+ cat + design).
    [OK] : Emulateur SuperNintendo via zsnes + config par defaut
    [EN COUR] : Etude sur steam


## archbox_5drivers.sh


    #### Script uniquement d'indiquation pour installer le bon drivers vidéo.
    
    [OK] : Installation automatique des drivers du RPI [HopeNux, DOcGui]
    [OK] : Optimisation du script (+ cat + design).
    [OK] : Drivers pour lancer le script sur des machines virtuels.


## archbox_6boot.sh


    #### Script intégrant quelques configurations et un script de démarrage (ARCHBOXBOOT).
    
    [OK] : Configurration Ip fixe ou dhcp + DNS
    [OK] : Démarrage automatique (autologin, upower, devmon)
    [OK] : ARCHBOXBOOT / Compatible télécommande
    [OK] : Archboxboot automatiquement lance
    [OK] : Optimisation du script (+ cat + design)
    [OK] : Prise en compte du nouvel utilisateur (autologin) [HopeNux]
    [OK] : Démarrage du RPI pris en compte (getty.service)
    [OK] : Démarrage du RPI pris en compte (getty.service)


## SOUS REPERTOIRES :


archbox-boot (archboxboot) [contribution HopeNux, Xorg, DOcGui]

    service archbox (utile si la personne ne souhaite pas d'interface de lancement)
    autologin
    démarrage et conf SSH + Proxy
    archboxboot (interface de démarrage avec sélection)


archbox-network [contribution HopeNux]

    service ip fixe
    dns par défaut
    configuration samba
    netctl configuration par defatu


archbox-theme [contribution Xorg, HopeNux(MAJ)]

    thème xfce avec barre + config par defaut


archbox-opt [contribution HopeNux]

    script github download
    script mise à jour arch
    script gestion des erreurs
    script memo installation rapide de arch (bootstrap...)

archbox-img [contribution de n3os]

    images de fond d'ecran par defaut

