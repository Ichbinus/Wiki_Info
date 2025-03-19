<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Gestion des logs chez CISCO</h1>
</div>

---
# Table des matières
- [Sauvegarde de la configuration](#sauvegarde-de-la-configuration)
- [Restauration de la configuration](#restauration-de-la-configuration)
- [Comparaison et validation de configuration](#comparaison-et-validation-de-configuration)
- [Bonnes pratiques](#bonnes-pratiques)

---
# Introduction
La gestion des configurations sur les équipements Cisco est essentielle pour assurer la continuité du service et faciliter la récupération en cas de problème. Il est possible de sauvegarder et restaurer les configurations à l’aide de plusieurs méthodes : **TFTP, FTP, SCP, USB, et stockage local**.
# Sauvegarde de la configuration
## Sauvegarde sur un serveur TFTP
- Pour sauvegarder la configuration en cours sur un serveur TFTP :
    ```ios
    Router# copy running-config tftp
    Address or name of remote host []? 192.168.1.100
    Destination filename [router-config]? backup.cfg
    ```
## Sauvegarde sur un serveur FTP
- Pour envoyer la configuration sur un serveur FTP :
    ```ios
    Router# copy running-config ftp://admin:password@192.168.1.100/backup.cfg
    ```
## Sauvegarde sur un serveur SCP
- Si l’équipement supporte SCP, il est recommandé pour plus de sécurité :
    ```ios
    Router# copy running-config scp://admin@192.168.1.100/backup.cfg
    ```
## Sauvegarde sur un périphérique USB
- Si le routeur possède un port USB :
    ```ios
    Router# copy running-config usbflash0:backup.cfg
    ```
## Sauvegarde en mémoire flash locale
- Il est possible de stocker la configuration directement sur la mémoire flash :
    ```ios
    Router# copy running-config flash:backup.cfg
    ```
# Restauration de la configuration
## Restauration depuis un serveur TFTP
```ios
Router# copy tftp running-config
Address or name of remote host []? 192.168.1.100
Source filename []? backup.cfg
```
## Restauration depuis un serveur FTP
```ios
Router# copy ftp://admin:password@192.168.1.100/backup.cfg running-config
```
## Restauration depuis un périphérique USB
```ios
Router# copy usbflash0:backup.cfg running-config
```
## Restauration depuis la mémoire flash locale
```ios
Router# copy flash:backup.cfg running-config
```
# Comparaison et validation de configuration
## Comparer la configuration actuelle avec une sauvegarde
```ios
Router# show archive config differences flash:backup.cfg
```
## Vérifier la dernière configuration enregistrée en mémoire NVRAM
```ios
Router# show startup-config
```
## Appliquer la configuration sans écraser la configuration en cours
```ios
Router# configure replace tftp://192.168.1.100/backup.cfg
```
# Bonnes pratiques
- **Automatiser les sauvegardes** avec un serveur centralisé.
- **Utiliser SCP ou FTP sécurisé** au lieu de TFTP pour plus de sécurité.
- **Vérifier les configurations avant de les appliquer** pour éviter toute interruption du service.
