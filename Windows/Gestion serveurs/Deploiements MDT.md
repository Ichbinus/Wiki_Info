<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://www.gabinhocity.eu/wp-content/uploads/2015/10/wds.png" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Services de déploiements des postes (MDT/WDS)</h1>
</div>

---
# Solutions possibles
   <details>
    <summary>WDS : Windows Deployment Services</summary>
    
   - Intègre un service PXE et TFTP
   - Permet aux machines ciblées de démarrer via le réseau et de déployer une image standard ou personalisée
   - Fourni avec Windows Server
   </details>
   <details>
    <summary>MDT : Microsoft Deployment Toolkit</summary>
    
   - Ensemble d’outils liés au déploiement de Windows
   - Peuvent être utilisés pour automatiser les tâches de déploiement
   - Installeur téléchargeable sur le site de Microsoft "<liens à ajouter>"
   </details>
   <details>
    <summary>ConfigMgr : Configuration Manager</summary>
    
   - Solution « haut de gamme » pour la gestion des systèmes et applicatifs
   - Pour le suivi, le déploiement et la mise à jour des appareils sur toute leur durée de vie
   - Initialement dans la suite System Center (SCCM), maintenant dans Microsoft Endpoint Manager
   </details>

---
# Prérequis

- Active Directory pour la gestion centralisée des utilisateurs et ressources
    - liens vers la fiche de mise en place d'un active directory
- DNS pour la résolution des noms en adresses IP
    - liens vers la fiche de mise en place d'un dns
- DHCP pour la fourniture d’adresses IP
    - liens vers la fiche de mise en place d'un dhcp

---
# WDS
## Objectifs et limites du service WDS
   <details>
    <summary>Objectifs</summary>
    
   - Fournir les informations nécessaires à l’amorçage de postes clients via le réseau
    - Héberger des images d’amorçage et d’installation et les transmettre aux clients
   - Intégrer des pilotes à des images
   </details>
   <details>
    <summary>Limites</summary>
    
   - Ne permet pas l'automatisation des installations
   - Ne permet pas de pousser les installation de programme tiers automatiquement sur les machines
   - Nécessite MDT pour être pleinement utilisable en entreprise
   </details>

---
## Installation du rôle WDS
### Rôle à ajouter:

- [ ] Services WDS

### Service du Rôle à installer:

- [ ] Serveur de déploiement
- [ ] Serveur de transport

### Paramétrage de base: 

- [ ] ajouter le serveur au réseau cible
- [ ] prévoir une partition spécifique pour héberger la gestion du service

---
## Config initiale

- Ouvrir la console de gestion
    
    ![Config_initiale_WDS_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Config_initiale_WDS_1.png) 
    
    - faire un clic droit sur le serveur puis sur Configure Server
        
        ![Config_initiale_WDS_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Config_initiale_WDS_2.png) 
        
- Renseigner
    - Le contexte de mise en oeuvre du service en ou hors contexte de domaine
    - Le dossier de partage des données du service (images) : prévoir un espace disque dédié et disposant d’une capacité suffisante
    - La configuration de restriction de réponse du serveur PXE : pour tous ou ciblage de certains hôtes
- DHCP:
    - Si le serveur faisant WDS fait également DHCP, cocher les 2 cases de l’assistant, dans le cas contraire, les laisser vides.
        
        ![Config_initiale_WDS_3](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Config_initiale_WDS_3.png) 
        
- Boot
    - Si l’on souhaite que les clients DHCP accrochent le PXE sans action particulière, le paramétrage suivant est à réaliser
        
        ![Config_initiale_WDS_4](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Config_initiale_WDS_4.png) 
        
---
## Ajout d’image de démarrage

- Depuis la console de gestion WDS faire un clic droit sur le conteneur d’images de démarrage
    - Cliquer sur Ajouter une image de démarrage
        - Indiquer le chemin du fichier WIM souhaité
            - Cela peut être le fichier boot.wim du répertoire Sources du média d’installation de Windows (exemple: explorer un cd d’install)
            
            ![image_boot_WDS_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_boot_WDS_1.png)

---
## Ajout d’image d’installation

- Depuis sa console de gestion faire un clic droit sur le conteneur d’images d’installation
- Cliquer sur Ajouter une image d’installation
    - Une image d’installation doit être associée à un groupe d’images
    - Si celui-ci n’est pas créé en amont, l’assistant permet de le créer
- Indiquer le chemin de l’image WIM
    - Il est possible de cibler le fichier install.wim du média d’installation
    - Ou d’indiquer le chemin d’une image WIM précédemment capturée
    - Ou de toute autre image WIM d’installation
>⚠️ Si dans le média d’installation il n’y à pas de ***install.win*** mais un ***install.esd*** il faut procéder à une conversion via powershell
   <details>
    <summary>Conversion install.esd</summary>
    
   - se placer dans le dossier ou est le fichier .esd
   - Récupération des versions de Win contenues dans l'esd
   ```powershell
   dism /Get-WimInfo /WimFile:install.esd
   ```
   - Création du fichier install.win 
   ```powershell
   dism /export-image /SourceImageFile:install.esd /SourceIndex:X_VERSION_DE_WINDOWS /DestinationImageFile:install.wim /Compress:max /CheckIntegrity
   ```
   >⚠️ le numéro de la version que l'on souhaite ajouté à WDS est à saisir en lieu et place de X_VERSION_DE_WINDOWS dans la commande ci-dessous   
   </details>

---
## Création d’un image de capture
>⚠️ Une image de capture est une image de boot spécifique qui va permettre de capturer l’installation d’une machine sysprepé en gardant ses spécificitées (partages, logiciels,…)
- Depuis une image de boot:
    - faire un clic droit et choisir Créer une image de capture
        
        ![image_boot_WDS_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_capture_MDT_1.png)
        
        - L’assistant de création d’image de capture se lance
        - Renseigner un nom et un chemin de stockage de l’image à capturer
        
        ![image_boot_WDS_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_capture_MDT_2.png)
        
- Cliquer sur Ajouter une image d’installation
    - Une image d’installation doit être associée à un groupe d’images
    - Si celui-ci n’est pas créé en amont, l’assistant permet de le créer
- Indiquer le chemin de l’image WIM
    - Il est possible de cibler le fichier install.wim du média d’installation
    - Ou d’indiquer le chemin d’une image WIM précédemment capturée
    - Ou de toute autre image WIM d’installation

---     
## Capture d’un image sysprepé

- booter la machine à capturer en PXE depuis l’image de capture
    
    ![image_sysprep_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_sysprep_1.png)
    
- Après avoir ciblé le volume sur lequel se trouve le système d’exploitation à capturer, associer un nom à cette image
    
    ![image_sysprep_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_sysprep_2.png)
    
- Renseigner ensuite
    - Le chemin du répertoire local dans lequel sera stocké l’image de capture durant sa création
    - Le groupe d’image dans lequel sera stocké la capture dans WDS
        
        ![image_sysprep_3](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_sysprep_3.png)
---
# MDT
## Installation MDT
- MDT nécessite des composants complémentaires
    - Windows ADK - Windows Assessment and Deployment Kit
        liens windows ADK à jouter
    - WinPE – Windows Preinstallation Environment
        liens windows PE à ajouter
- Procédure:
    - Télécharger les dernières versions sur le site de Microsoft
    - Lancer l’installeur
        - Nécessite une connexion Internet
        - Un mode hors ligne est proposé
    - Sélectionner les composants souhaités pour ADK
        - Au minimum installer les fonctionnalités cochées ci-dessous
        
        ![Install_MDT_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Install_MDT_1.png)
        
        ![Install_MDT_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Install_MDT_2.png)
---
## Configuration initiale MDT
- Ouvrir la console de gestion Deployment Workbench
![Config_initiale_MDT_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/Config_initiale_MDT_1.png)
    
   - faire un clic droit sur Deployment Share puis New Deployment Share
   ![config_initial_MDT_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/config_initial_MDT_2.png)
        
- Renseigner
    - Le chemin du dossier de déploiement
        - Celui-ci pourra être créé (si inexistant)
    - Le nom et la description du partage
        >⚠️ Prévoir un espace disque suffisant
        
- L’assistant propose ensuite de passer un ensemble d’étapes d’installation
    - Les choix sélectionnés sont traduits en paramètres de configuration dans le fichier CustomSettings.ini
        - ⇒ donc pas la peine de s’y interesser à cette étape
---
## Paramètrage du Partage de déploiement
>⚠️ Une mise à jour du partage déploiement est nécessaire après toute modification
>![partage_deploiement_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/partage_deploiement_1.png)
- Les paramétrages sont disponibles dans les propriétés du partage de déploiement
    - Onglet General
        - Paramètres généraux et activation du multicast (via WDS)
    - Onglet Rules
        - Configuration des fichiers Bootstrap.ini et CustomSettings.ini
    - Onglet Windows PE
        - Paramétrage des médias de démarrage (x86 et x64)
    - Onglet Monitoring
        - Activation du suivi des déploiements dans la console de gestion
---
## Image de démarrage

- Contrairement à WDS, c’est généré à partir du partage de déploiement
    - Format WIM et ISO disponibles, pour les architectures 32 et 64 bits
    - Fichiers stockés dans le répertoire Boot de l’arborescence du partage de déploiement
---
## Ajout d’image d’installation

- Une image de système d’exploitation à déployer doit être associée au partage de déploiement
    - Pour en ajouter une, faire un clic droit sur le conteneur Operating Systems puis Importer
    - Plusieurs choix sont alors proposés par l’assistant
        - Indiquer un chemin de média d’installation
        - Indiquer le chemin d’un fichier WIM ciblé
        - Aller chercher dans les images intégrées au service WDS ⇒ si un WDS existe c’est ça qu’il faut choisir.
            
            ![image_install_WDS_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/image_install_WDS_1.png)
---
## Automatisation de déploiement
>⚠️ Bootstrap.ini et Customsettings.ini sont accessible via les propriétés du partage de déploiement onglet Rules
>![automat_deploiemt_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/automat_deploiemt_1.png)
### Bootstrap.ini
- Agit sur le boot lors du déploiement (Win PE)
- Ce fichier contient les informations nécessaires à l’environnement Windows PE
    - Pour permettre l’accès au partage de déploiement
    - [optionnellement] pour paramétrer l’environnement WinPE
- Pour la prise en compte des modifications de ce fichier, il est nécessaire :
    - Dans MDT, de mettre à jour le partage de déploiement,ce qui regénère l’image de boot MDT (LiteTouchPE_x64.wim)
    - Dans WDS, de remplacer l’image de démarrage correspondante
- exemple de ***Bootstrap.ini***:
    ```powershell
        [Settings]
        Priority=Default
        [Default]
        DeployRoot=\\WDS\DeploymentShare$
        UserID=mdt
        UserDomain=deploy.eni
        UserPassword=Pa$$w0rd
        KeyboardLocale=fr-FR
        KeyboardLocalePE=040c:0000040c
        SkipBDDWelcome=YES
    ```
### Customsettings.ini
- Agit sur le déploiement (installation windows)
- Un grand nombre de paramètres peut être renseigné dans ce fichier
- L’exemple ci-dessous permet d’automatiser le processus de déploiement du système à déployer
- La mise à jour de ce fichier ne requiert pas la mise à jour du partage de déploiement
- exemple de ***Customsettings.ini***:
    ```powershell
        [Settings]
        Priority=Default
            
        [Default]
        #Interactivité avec l'installateur
        SkipTaskSequence=YES
        TaskSequenceID=ENISALLE09
        SkipUserData =YES
        SkipApplications=YES
        SkipAppsOnUpgrade=YES
        SkipAdminPassword=YES
        AdminPassword=ENI-demo!local
        
        #Nommage et Domaine
        SkipComputerName=YES
        OSDComputerName=ENI-DEMO
        SkipDomainMembership=YES
        JoinDomain=deploy.eni
        DomainAdmin=mdt
        DomainAdminDomain=deploy.eni
        DomainAdminPassword=Pa$$
            
        #Paramètres régionaux
        SkipLocaleSelection=YES
        SkipTimeZone=YES
        UserLocale=fr-FR
        KeyboardLocale=040C:0000040C
        TimeZoneName=Romance Standard Time
        SkipCapture=YES
        SkipBitlocker=YES
        SkipSummary=YES
            
        #Activation Windows
        SkipProductKey=YES
        ; clé KMS pour W10 Pro N
        ProductKey=MH37W-N47XK-V7XM9-C7227-GCQG9
    ```
### Task Sequence
- La séquence de tâches permet d’automatiser la réalisation des actions réalisées pendant le déploiement
- Click droit sur l’UO task sequence du partage de déploiement
    - puis new Task Sequence
            
        ![task-sequence_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/task-sequence_1.png)
            
    - un assistant s’ouvre la paramétrer.
    - Elle peut être modifier après création
### Déploiement d’applications
- Click droit sur l’UO application du partage de déploiement
    - puis new application
            
        ![app_déploiement_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/app_déploiement_2.png)
            
    - **Etape 1 :** Application Type
        - Indiquer si l’on fournit l’installeur à l’assistant qui se charge de l’importer dans la structure du partage de déploiement
        - Ou
        - Si l’application est à disposition sur un partage réseau
        - Ou
        - S’il s’agit d’un groupe d’applications
                
            ![app_déploiement_3](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/app_déploiement_3.png)
                
    - **Etape 2 :** installateur
        - Les caractéristiques de l’application
                
            ![app_déploiement_4](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/app_déploiement_4.png)
                
        - Le chemin de répertoire dans lequel se trouve l’installeur (créer un répertoire dédié)
        - Le nom du dossier qui sera créé dans l’arborescence du partage de déploiement et contiendra l’installeur
        - La commande permettant l’installation silencieuse et non interactive de l’application
            - exemple
                    
                ![app_déploiement_5](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/app_déploiement_5.png)
                    
    - **Etape 3:**  associer l’application à un task sequence
        - Une ou plusieurs applications peuvent être associées à une séquence de tâches pour être installées après le déploiement du système
        - La capture ci-contre présente le cheminement permettant d’ajouter une application à installer à une séquence de tâches.
        - Enfin, cocher la case Install a single application et la cibler
                
            ![app_déploiement_6](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/app_déploiement_6.png)
---
## Sécurité du déploiement
- L’accès aux ressources du partage de déploiement peut être restreint
    - Un compte de service peut être utilisé
    - Au moyen d’entrées de contrôle d’accès configurées
        - Sur le partage ou
        - Via les autorisations NTFS
            
            ![déploiement_secure_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Deploiement_images/déploiement_secure_1.png)