# Ajout de disque dur/SSD/...

<details>
  <summary>Exemple de procédure</summary>

    ```bash
    # Configuration disques, LVM et FS sur SVDB11
    
    # Configuration disques, LVM et FS sur SVDB11
    
    # LVM : Liste des volumes logiques
    lvdisplay
    
    # LVM : Liste des groupes de volumes
    vgdisplay
    
    # LVM : liste des volumes physiques
    pvdisplay
    
    # Affichage arborescent des disques, partitions et volumes présents sur le système 
    lsblk
    
    # Affichage personnalisé incluant en plus le type de système de fichiers présent 
    # sur le volume ainsi que son UUID et son LABEL
    lsblk -o NAME,SIZE,RO,TYPE,MOUNTPOINT,FSTYPE,UUID,LABEL
    
    # Partitionnement des deux nouveaux disques en vue de leur intégration à LVM 
    # (on n'intègre pas un disque entier à LVM mais bien une partition qu'on transforme en PV)
    # Outil de partitionnement en ligne de commande interactif fdisk (lancé sur le disque sdb)
    fdisk /dev/sdb # table de partition en GPT, création partition 1, préparation en type LVM (30), taille 30G
    fdisk /dev/sdc # table de partition en GPT, création partition 1, préparation en type LVM (30), taille 20G
    # m - afficher aide
    # g - création table de partitions au format gpt
    # n - nouvelle partition
    # t - changement type partition 
    # w - écrire les changements
    
    # Vérification création partitions (un sdb1 de 30Go et un sdc1 de 20Go doivent apparaitre)
    lsblk -o NAME,SIZE,RO,TYPE,MOUNTPOINT,FSTYPE,UUID,LABEL
    
    # Intégration des nouvelles partitions à LVM (création de PV)
    pvcreate /dev/sdb1
    pvcreate /dev/sdc1
    pvdisplay
    
    # Extension du VG créé à l'installation de l'OS avec les deux nouveaux PV
    # (contrôle avant et après à l'aide de la commande vgdisplay)
    vgdisplay
    vgextend VG-OS /dev/sdb1 /dev/sdc1
    vgdisplay
    
    # Redimensionnement du LV et du FS lié à /home
    lvresize --size +6G /dev/VG-OS/LV-HOME
    resize2fs /dev/mapper/VG--OS-LV--HOME
    
    # Création d'un LV LV-VAR2 (sera utilisé pour stocker le contenu de /var après migration)
    # Formattage de celui-ci en ext4
    lvcreate --name LV-VAR2 --size 10G VG-OS
    mkfs.ext4 -L FS-VAR2 /dev/mapper/VG--OS-LV--VAR2
    
    # Création d'un LV LV-PROJETS
    # Formattage (installation du FS XFS pour pouvoir formatter avec celui-ci)
    aptitude install xfsprogs
    lvcreate --name LV-PROJETS --size 25G VG-OS
    mkfs.xfs -L FS-PROJETS /dev/mapper/VG--OS-LV--PROJETS
    
    # Vérification
    lsblk -o NAME,SIZE,RO,TYPE,MOUNTPOINT,FSTYPE,UUID,LABEL   
    ```
</details>
    
1. ajouter physiquement le disque
2. Passer en root
    
    ```bash
    su -
    ```
    
3. faire apparaitre la liste des disques
    - lister les disques (devices) de la machine
        
        ```bash
        ls /dev
        #les devices seront listés
        ```
        
    - avoir une vue d’ensemble des volume
        
        ```bash
        lsblk 
        #ajouter l’option -f pour avoir également aussi le format de fichier
        ```
        
    - on peut cibler un volume en ajoutant un chemin
        
        ```bash
        lsblk -f <chemin du périphérique>
        #exemple
        	lsblk -f /dev/sdb
        ```
        
4. partitionnement du disque
    - créer un partition
        
        ```bash
        fdisk <chemin du périphérique>
        #exemple 
        	fdisk /dev/sbd
        ```
        
5. gestion volume 
    - Création Volume de groupe
        
        ```bash
        vgcreate <nom du VG> <device 1 à ajouter> <device 2 à ajouter> ...
        #exemple
        	vgcreate LVM /dev/sdc1 /dev/sdd1
        ```
        
    - création nouveau volume
        
        ```bash
        lvcreate -n <nom volume> -L <taille volume> <nom volume groupe>
        #exemple
        	lvcreate -n LVM-var -L 20G /dev/mapper/LVM
        ```
        
    - Agrandir 1 volume logique avec le reste de l’espace disponible du groupe de volume
        
        ```bash
        lvextend -l <taille> <chemin du volume à agrandir>
        #exemple
        	lvextend -l +100%FREE /dev/mapper/LVM/LVM-var
        ```
        
6. Intégrer la partition au groupe de volume présent dans votre système.
    
    ```bash
    vgextend <groupe de volume> <chemine de la partition>
    #exemple 
    	vgextend /dev/LVM/VLM-var /var
    ```
    
7. gestion file system
    - configurer un système de fichier ext4 avec une étiquette
        
        ```bash
        mkfs.<format de systeme de fichier> -L <label> <chemin du volume concerné>
        #exemple
        	mkfs.ext4 -L VAR /dev/mapper/LVM/LVM-var
        ```
        
    - prise en compte des modification de taille de système de fichier
        
        ```bash
        resize2fs -p <chemin du volume concerné>
        #exemple
        	resize2fs -p /dev/mapper/LVM/LVM-var
        ```
        