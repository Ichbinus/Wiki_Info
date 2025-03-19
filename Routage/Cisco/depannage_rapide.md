<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Dépannage Rapide chez CISCO</h1>
</div>

---
# Table des matières
- [récupération et modification de mot de passe sur un routeur Cisco](#proc%C3%A9dure-de-r%C3%A9cup%C3%A9ration-et-modification-de-mot-de-passe-sur-un-routeur-cisco)

---
# Procédure de récupération et modification de mot de passe sur un routeur Cisco
## Introduction
En cas de perte du mot de passe administrateur d’un routeur Cisco, il est possible de le récupérer ou le modifier en suivant une procédure spécifique. Cette procédure implique le mode **ROMMON**, la modification du registre de configuration et la récupération de la configuration.
## Étape 1 : Activer le mode ROMMON
1. Redémarrer le routeur.
2. Lors du démarrage, interrompre la séquence de boot en appuyant sur `Ctrl + Break` (ou `Ctrl + Pause`) au bon moment.
3. Le routeur entre en mode **ROMMON**, affichant l’invite de commande `rommon>`.
## Étape 2 : Modifier le registre de configuration
- Dans le mode **ROMMON**, modifier le registre pour empêcher le chargement de la configuration de démarrage :
    ```ios
    rommon> confreg 0x2142
    ```
  >💡 Cela permet au routeur de démarrer sans charger la configuration stockée dans la NVRAM.

- Redémarrer ensuite le routeur :
    ```ios
    rommon> reset
    ```
## Étape 3 : Copier la configuration de démarrage dans la configuration d'exécution
- Une fois le routeur redémarré, il ne demandera plus de mot de passe. Passer en mode privilégié (`enable`) et restaurer la configuration sauvegardée :
    ```ios
    Router> enable
    Router# copy startup-config running-config
    ```
  >💡 Cette commande récupère les anciennes configurations (dont les interfaces et utilisateurs).
## Étape 4 : Modifier le mot de passe
- Changer le mot de passe administrateur :
    ```ios
    Router# configure terminal
    Router(config)# enable secret newpassword
    ```
- Si nécessaire, modifier les mots de passe des lignes VTY et console :
    ```ios
    Router(config)# line vty 0 4
    Router(config-line)# password newpassword
    Router(config-line)# login
    Router(config-line)# exit
    Router(config)# line console 0
    Router(config-line)# password newpassword
    Router(config-line)# login
    Router(config-line)# exit
    ```
## Étape 5 : Enregistrer la configuration
- Reconfigurer le registre pour charger normalement la configuration au prochain redémarrage :
    ```ios
    Router(config)# config-register 0x2102
    Router(config)# exit
    Router# write memory
    ```
  >💡 Cela permet au routeur de charger la configuration normalement après redémarrage.
## Étape 6 : Redémarrer l’appareil
- Redémarrer le routeur pour appliquer définitivement les modifications :
    ```ios
    Router# reload
    ```
