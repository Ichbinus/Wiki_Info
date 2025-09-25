# **Installation**

1. Accéder au fichier `sources.list`
    
    ```bash
    vi /etc/apt/sources.list
    ```
    
2. Saisir les références des paquets sélectionnés.
3. Mettre à jour la base de données des paquets en fonction des modifications faites.
    
    ```bash
    apt update
    ```
    
4. Mettre à jour les paquets.
    
    ```bash
    apt upgrade
    # Permet de supprimer les paquets enlevés de la liste
    ```
    
# **Mise à jour des paquets**

1. Accéder au fichier `sources.list`
    
    ```bash
    vim /etc/apt/sources.list
    ```
    
2. Désactiver les paquets non désirés en ajoutant `#` devant la ligne non souhaitée.
3. Ajouter / corriger les lignes de la liste des paquets.
4. Mettre à jour la base de données des paquets en fonction des modifications faites.
    
    ```bash
    apt update
    ```
    
5. Mettre à jour les paquets.
    
    ```bash
    apt upgrade
    # Permet d’installer les paquets à mettre à jour
    ```
    
    ```bash
    apt full-upgrade  
    # Permet de mettre à jour tout, tout en supprimant les paquets enlevés de la liste
    ```
    
    ```bash
    apt install <paquet>
    # Permet d’installer un paquet spécifique
    ```
    
6. Installer à partir d’une source.
    
    ```bash
    # Une fois dans le dossier (décompressé) du paquet.src
    ./configure  # Crée toutes les dépendances du paquet
    make         # Préparation de la compilation
    make install # Créé le binaire exécutable
    cp "binaire à mettre à dispo" /usr/local/
    ```
    
# **Supprimer un paquet**

```bash
apt remove <paquet> 
# Enlève les paquets ciblés mais laisse les fichiers de configuration
```

```bash
apt purge <paquet>
# Enlève les paquets ciblés ainsi que les fichiers de configuration
```

# **Lister les paquets relatifs à un thème**

1. Installer le paquet `aptitude` (il n’est pas installé d’origine).

```bash
apt search <thème>
# Le thème peut être tout ce qui commence par vim (^vim) ou tout ce qui finit par la lettre d (d$)
```

- Cette commande affiche la liste des paquets (relatifs au thème) disponibles dans `sources.list` et indique s'ils sont installés ou non.

# **Lister les paquets installés**

```bash
apt list
# Interroge localement pour savoir les paquets installés sur la machine
```

# **Obtenir les informations d’un paquet**

```bash
apt show <paquet>
```

# **Trouver un paquet à l’origine d’un fichier**

```bash
dpkg -S <fichier>
```

# **Installer un autre noyau**

- Installation du noyau :
    
    ```bash
    apt install <nom_autre_noyau>
    ```
    
- Mise à disposition du nouveau noyau :
    
    ```bash
    # Modifier le fichier de configuration du GRUB pour afficher la version
    vim /etc/default/grub
    
