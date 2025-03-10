<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Configuration réseau OSPF chez CISCO</h1>
</div>
---

#  Activation d'OSPF sur le Routeur
```ios
conf t
router ospf "id proccessus"
exit
```
>- **l'ID processus** correspond à un pool de gestion ospf. Tous les routeur/interface en ospf 10 interagirons ensemble.
- exemple
    ```ios
    conf t
    router ospf 10
    exit
    ```
---
# Configurer un ID de Routeur
## Configuration explicite
```ios
conf t
router ospf "id proccessus"
router-id "id routeur"
end
```
- exemple
    ```ios
    conf t
    router ospf 10
    router-id 1.1.1.1
    end
    ```
### Modification d'un ID de routeur
- Procéder à une nouvelle configuration de l'ID du routeur et faire un reset des paramètres ospf
```ios
conf t
router ospf "id proccessus"
router-id "id routeur"
end
clear ip ospf process
```
- exemple
    ```ios
    conf t
    router ospf 10
    router-id 1.1.1.1
    end
    clear ip ospf process
    ```
## Configuration via interface de bouclage
```ios
conf t
interface Loopback "id interface loopback"
ip address "id routeur" 255.255.255.255
end
```
- exemple
    ```ios
    conf t
    interface Loopback 1
    router-id 1.1.1.1
    end
    ```
## Configuration via IPv4 active
- Si aucun ID de routeur n'est configurée, l'adresse IPv4 configurée et active la plus élevée sera utilisée automatiquement.
---
# Configuration OSPF
## Via la commande *network*
### A partir de l'adresse réseau à router
```ios
conf t
router ospf "id proccessus"
network "réseau n°1 à router" "wildmask du réseau n°1 à router" area "zone réseau"
network "réseau n°2 à router" "wildmask du réseau n°2 à router" area "zone réseau"
```
>- La **zone réseau** correspond à un ensemble de routeur.
- exemple
    ```ios
    conf t
    router ospf "id proccessus"
    network 10.10.1.0 0.0.0.255 area 5
    network 10.1.1.4 0.0.0.3 area 5
    ```
### A partir de l'adresse d'interface
```ios
conf t
router ospf "id proccessus"
network "adresse IP 1ere interface" 0.0.0.0 area "zone réseau"
network "adresse IP 2eme interface" 0.0.0.0 area "zone réseau"
```
- exemple
    ```ios
    conf t
    router ospf "id proccessus"
    network 10.10.1.1 0.0.0.0 area 5
    network 10.1.1.5 0.0.0.0 area 5
    ```
## Via la commande *ip ospf*
```ios
interface GigabitEthernet X/X/X
ip ospf "id proccessus" area "zone réseau"
interface Serial X/X/X
ip ospf "id proccessus" area "zone réseau"
interface Loopback X
ip ospf "id proccessus" area "zone réseau"
```
- exemple
    ```ios
    interface GigabitEthernet 0/0/0
    ip ospf 10 area 5
    interface Serial 0/0/0
    ip ospf 10 area 5
    interface Loopback 1
    ip ospf 10 area 5
    ```
# Configurer des interfaces passives
- But:
    - cela va désactiver l'envoie de message "hello" sur les interfaces désactivées. 
- Avantage:
    - évite l'interception des message "hello" par un attaquant sur le réseau
    - soulage le réseau en évitant les messages inutiles.
```ios
conf t
router ospf "id proccessus"
passive-interface "ID interface n°1"
passive-interface "ID interface n°2"
end
```
- exemple
    ```ios
    conf t
    router ospf 10
    passive-interface GigabitEthernet 0/0/0
    passive-interface loopback 0
    end
    ```
# Configuration du type de réseau
- types de réseau admis:
    <details>
    <summary>point-to-point</summary>

    - **avantages**:
        - Configuration simple
        - Pas d'élection de routeur désigné (DR) et de routeur de secours (BDR), ce qui réduit la complexité
        - Convergence rapide
    - **inconvénients**:
        - Nécessite une interface dédiée pour chaque liaison, ce qui peut consommer plus de ports
    </details>
    <details>
    <summary>broadcast</summary>
    
    - **avantages**:
        - Nécessite une interface dédiée pour chaque liaison, ce qui peut consommer plus de ports
        - Économie d'adresses IP grâce à l'utilisation d'un segment partagé
    - **inconvénients**:  
        - Élection d'un DR et d'un BDR, ce qui peut ralentir la convergence en cas de changement
        - Sensible aux tempêtes de broadcast si mal configuré 
    </details>
     
```ios
conf t
interface GigabitEthernet X/X/X
ip ospf network "type de réseau"
end
```
- exemple
    ```ios
    conf t
    interface GigabitEthernet X/X/X
    ip ospf network point-to-point
    end
    ```
# Configuration de la priorité OSPF
```ios
conf t
interface GigabitEthernet X/X/X
ip ospf priority XXX
clear ip ospf process
end
```
- exemple
    ```ios
    conf t
    interface GigabitEthernet 0/0/0
    ip ospf priority 255
    clear ip ospf process
    end
    ``` 
>Un priorité de 255 correspond à forcer un DR (priorité la + haute)
La bonne pratique pour le BDR consiste à mettre une priorité de 254.
Saisir une priorité de 0 empéchera le router de devenir DR ou BDR même en cas de pannes des autres routeurs.