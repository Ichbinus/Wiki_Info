<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Update images ios des équipements CISCO</h1>
</div>

---
# Table des matières
- [Étape 1 : Vérification de la version actuelle et de l’espace disponible](#étape-1--vérification-de-la-version-actuelle-et-de-lespace-disponible)
- [Étape 2 : Téléchargement de la nouvelle image IOS](#étape-2--téléchargement-de-la-nouvelle-image-ios)
- [Étape 3 : Sauvegarde de la configuration actuelle](#étape-3--sauvegarde-de-la-configuration-actuelle)
- [Étape 4 : Copie de l’image IOS sur l’équipement](#étape-4--copie-de-limage-ios-sur-léquipement)
- [Étape 5 : Configuration du fichier de démarrage](#étape-5--configuration-du-fichier-de-démarrage)
- [Étape 6 : Redémarrage et vérification](#étape-6--redémarrage-et-vérification)
---
# Introduction
- La mise à jour de l'IOS d'un équipement Cisco est une tâche essentielle pour garantir la sécurité, la stabilité et l'ajout de nouvelles fonctionnalités. Cette procédure décrit les étapes nécessaires pour effectuer une mise à jour en toute sécurité.
---
# Étape 1 : Vérification de la version actuelle et de l’espace disponible
- Avant toute mise à jour, il est important de vérifier la version actuelle de l'IOS et l’espace disponible sur la mémoire flash :
    ```bash
    Router# show version
    Router# show flash:
    ```
- Si l’espace est insuffisant, il peut être nécessaire de supprimer l’ancienne image IOS :
    ```bash
    Router# delete flash:ancienne_image.bin
    ```
---
# Étape 2 : Téléchargement de la nouvelle image IOS
- Téléchargez la nouvelle image IOS depuis le site officiel de Cisco et placez-la sur un serveur TFTP, FTP ou SCP accessible depuis l’équipement.
---
# Étape 3 : Sauvegarde de la configuration actuelle
- Avant d’effectuer la mise à jour, sauvegardez la configuration pour éviter toute perte de données :
    ```bash
    Router# copy running-config startup-config
    Router# copy startup-config tftp:
    ```
---
# Étape 4 : Copie de l’image IOS sur l’équipement
- Copiez la nouvelle image sur la mémoire flash de l’équipement depuis un serveur externe (TFTP, FTP, SCP) :
    ```bash
    Router# copy tftp: flash:
    ```
  >💡 Suivez les instructions à l’écran pour indiquer l’adresse du serveur et le nom du fichier.
---
# Étape 5 : Configuration du fichier de démarrage
- Une fois l’image téléchargée, configurez l’équipement pour démarrer sur la nouvelle version :
    ```bash
    Router(config)# boot system flash:new_image.bin
    Router(config)# exit
    Router# write memory
    ```
---
# Étape 6 : Redémarrage et vérification
- Redémarrez l’équipement pour appliquer la mise à jour :
    ```bash
    Router# reload
    ```
- Après le redémarrage, vérifiez que l’équipement utilise bien la nouvelle version :
    ```bash
    Router# show version
    ```

