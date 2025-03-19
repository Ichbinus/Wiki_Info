<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Réglage Horloge chez CISCO</h1>
</div>

---
# Vérification du réglage Horloge
```ios
Router# show clock detail
```
# Réglage Horloge
## En locale sur la machine

## Depuis un serveur NTP
### Prérequis
- un serveur NTP doit être déployé sur le réseau.
### Définir un serveur NTP
- Pour configurer un routeur Cisco afin qu'il se synchronise avec un serveur NTP :
    ```ios
    Router(config)# ntp server 192.168.1.1
    ```
- Si le serveur NTP est accessible via un nom de domaine :
    ```ios
    Router(config)# ntp server pool.ntp.org
    ```
### Vérifier l'état de la synchronisation NTP
- Pour afficher l'état de la synchronisation avec les serveurs NTP :
    ```ios
    Router# show ntp status
    ```
  >💡 Cette commande permet de vérifier si l'horloge est synchronisée et affiche des informations comme le décalage et la précision.

- Pour afficher la liste des serveurs NTP associés :
    ```ios
    Router# show ntp associations
    ```
### Définir le fuseau horaire
- Il est possible de configurer le fuseau horaire du routeur :
    ```ios
    Router(config)# clock timezone CET 1
    ```
  >💡 Ici, *CET* est le nom du fuseau horaire et *1* est le décalage en heures par rapport à UTC.

### Activer l'heure d'été
- Pour configurer l'heure d'été automatique :
    ```ios
    Router(config)# clock summer-time CEST recurring
    ```
## Configuration avancée
### Définir une source NTP de secours
- En cas de panne du serveur principal, on peut définir un serveur NTP secondaire :
    ```ios
    Router(config)# ntp server 192.168.1.2 prefer
    ```
### Configurer un routeur comme serveur NTP
- Un routeur peut être configuré pour servir d'horloge de référence :
    ```ios
    Router(config)# ntp master 3
    ```
  >💡 Le chiffre *3* représente le niveau de hiérarchie NTP (stratum), un chiffre bas indique une source plus fiable.
### Désactiver NTP sur une interface spécifique
- Si une interface ne doit pas recevoir d'informations NTP :
    ```ios
    Router(config)# interface GigabitEthernet0/1
    Router(config-if)# ntp disable
    ```
## Sécurité et bonnes pratiques
- **Restreindre les sources NTP autorisées** pour éviter les attaques NTP :
  ```ios
  Router(config)# ntp access-group peer 10
  ```
    >💡 Cette configuration permet uniquement aux adresses autorisées dans l'ACL *10* d'envoyer et de recevoir des requêtes NTP.
- **Utiliser NTP authentifié** pour garantir l'intégrité des informations de temps :
  ```ios
  Router(config)# ntp authenticate
  Router(config)# ntp authentication-key 1 sha-256 secretkey
  Router(config)# ntp trusted-key 1
  ```
- **Limiter les annonces NTP** sur les interfaces non sécurisées.