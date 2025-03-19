<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Decouverte réseau chez CISCO</h1>
</div>

---
# Table des matières
- [Protocole propriétaire: CDP](#decouverte_reseau.md#protocole-propri%C3%A9taire-cdp)
- [Protocole générique: LLDP](#decouverte_reseau.md#protocole-g%C3%A9n%C3%A9rique-lldp)

# Protocole propriétaire: CDP
## Activation et désactivation de CDP
- Par défaut, CDP est activé sur les équipements Cisco. Cependant, il peut être activé ou désactivé globalement ou par interface.
 >⚠️ La bonne pratique est d désactiver le protocole DCP pour qu'aucun attaquant ne puisse scanner le réseau à la recherche d'information réseau.
### Activer/Désactiver CDP globalement
- Pour activer CDP globalement :
  ```ios
  Router(config)# cdp run
  ```
- Pour désactiver CDP globalement :
  ```ios
  Router(config)# no cdp run
  ```
### Activer/Désactiver CDP sur une interface spécifique
- Pour activer CDP sur une interface :
  ```ios
  Router(config)# interface GigabitEthernet0/1
  Router(config-if)# cdp enable
  ```
- Pour désactiver CDP sur une interface :
  ```ios
  Router(config)# interface GigabitEthernet0/1
  Router(config-if)# no cdp enable
  ```
## Vérification des informations CDP
### Afficher les voisins CDP
- La commande suivante permet d'afficher les équipements voisins détectés :
  ```ios
  Router# show cdp neighbors
  ```
- Cette commande affiche des informations telles que l'ID du périphérique, le port local, le port distant et le type de plateforme.
  >💡 Capability Codes: 
  >R - Router, T - Trans Bridge, B - Source Route Bridge, S - Switch, H - Host, I - IGMP, r - Repeater, P - Phone, D - Remote, C - CVTA, M - Two-port Mac Relay
### Afficher les détails des voisins CDP
- Pour obtenir des informations plus détaillées sur un voisin spécifique :
  ```ios
  Router# show cdp neighbors detail
  ```
>💡 Cette commande affiche des détails supplémentaires comme l'adresse IP du voisin et le modèle du périphérique.
- On peut filtrer les données affichées:
  - Afficher uniquement les adresses IP des voisins:
    ```ios
    Router# show cdp entry *
    ```
## Configuration avancée de CDP
- Le protocole communique de façon régulières les informations. Pour consulter ces informations:
  ```ios
  Router(config)# show cdp
  ```
### Modifier l'intervalle d'envoi des annonces CDP
- L'intervalle par défaut est de **60 secondes**, mais il peut être modifié :
  ```ios
  Router(config)# cdp timer 30
  ```
  >💡 Cette commande ajuste l'intervalle à 30 secondes.
### Modifier le délai avant suppression d'un voisin CDP
- L'intervalle par défaut est de **180 secondes**, mais il peut être modifié :
  ```ios
  Router(config)# cdp holdtime 120
  ```
---
# Protocole générique: LLDP
## Activation et désactivation de LLDP
- Par défaut, LLDP est désactivé sur les équipements Cisco. Il peut être activé ou désactivé globalement ou par interface.
### Activer/Désactiver LLDP globalement
- Pour activer LLDP globalement :
  ```ios
  Router(config)# lldp run
  ```
- Pour désactiver LLDP globalement :
  ```ios
  Router(config)# no lldp run
  ```
### Activer/Désactiver LLDP sur une interface spécifique
- Pour activer LLDP sur une interface :
  ```ios
  Router(config)# interface GigabitEthernet0/1
  Router(config-if)# lldp transmit
  Router(config-if)# lldp receive
  ```
- Pour désactiver LLDP sur une interface :
  ```ios
  Router(config)# interface GigabitEthernet0/1
  Router(config-if)# no lldp transmit
  Router(config-if)# no lldp receive
  ```
## Vérification des informations LLDP
### Afficher les voisins LLDP
- La commande suivante permet d'afficher les équipements voisins détectés :
  ```ios
  Router# show lldp neighbors
  ```
  >💡 Cette commande affiche des informations telles que l'ID du périphérique, le port local, le port distant et le type de plateforme.
### Afficher les détails des voisins LLDP
- Pour obtenir des informations plus détaillées sur un voisin spécifique :
  ```ios
  Router# show lldp neighbors detail
  ```
  >💡 Cette commande affiche des détails supplémentaires comme l'adresse IP du voisin et le modèle du périphérique.
## Configuration avancée de LLDP
### Modifier l'intervalle d'envoi des annonces LLDP
- L'intervalle par défaut est de **30 secondes**, mais il peut être modifié :
  ```ios
  Router(config)# lldp timer 20
  ```
  >💡 Cette commande réduit l'intervalle à 20 secondes.
### Modifier le délai avant suppression d'un voisin LLDP
- L'intervalle par défaut est de **120 secondes**, mais il peut être modifié :
  ```ios
  Router(config)# lldp holdtime 90
  ```