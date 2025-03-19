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
- [Configuration de Syslog](#configuration-de-syslog)
- [Sécurisation de Syslog](#sécurisation-de-syslog)

---
# Configuration de Syslog
## Prérequis
- Un serveur de gestion des logs (syslog) doit être déployé sur le réseau
## Définir un serveur Syslog
- Pour configurer un routeur ou un switch Cisco afin d'envoyer ses logs vers un serveur Syslog :
    ```ios
    Router(config)# logging host 192.168.1.100
    ```
  >💡 Cette commande envoie les messages Syslog au serveur situé à l'adresse `192.168.1.100`
## Définir le niveau de gravité des logs
- Les messages Syslog sont classés selon différents niveaux de gravité (de 0 à 7) :
    - **0 - Emergencies** : Système inutilisable
    - **1 - Alerts** : Action immédiate requise
    - **2 - Critical** : Conditions critiques
    - **3 - Errors** : Erreurs signalées
    - **4 - Warnings** : Avertissements
    - **5 - Notifications** : Messages informatifs
    - **6 - Informational** : Messages détaillés
    - **7 - Debugging** : Messages de débogage
- Pour limiter l'envoi des logs à un certain niveau de gravité :
    ```ios
    Router(config)# logging trap warnings
    ```
  >💡 Cette configuration envoie uniquement les logs de niveau `warnings` (4) et plus critiques (0 à 4).
## Activer la journalisation locale
- Il est possible d'enregistrer les logs localement sur l'équipement :
    ```ios
    Router(config)# logging buffered 4096
    Router(config)# logging console warnings
    ```
- Explication:
    - `logging buffered 4096` : Stocke les logs en mémoire tampon jusqu'à 4096 octets.
    - `logging console warnings` : Affiche uniquement les logs de niveau `warnings` et plus critiques sur la console.
## Afficher les logs enregistrés
- Pour afficher les logs stockés dans le buffer du routeur :
    ```ios
    Router# show logging
    ```
---
# Sécurisation de Syslog
- **Restreindre l'accès au serveur Syslog** en utilisant des listes de contrôle d'accès (ACL) :
  ```ios
  Router(config)# access-list 10 permit 192.168.1.100
  Router(config)# logging host 192.168.1.100 transport udp port 514
  ```
- **Utiliser un transport sécurisé comme TCP** au lieu d'UDP pour éviter la perte de logs :
  ```ios
  Router(config)# logging host 192.168.1.100 transport tcp
  ```
- **Activer l’horodatage des logs** pour faciliter l’analyse :
  ```ios
  Router(config)# service timestamps log datetime msec
  ```