<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Configuration ACL sur les routeurs CISCO</h1>
</div>

# Concept des ACL
- Une ACL (*Control Access List*) est constituées d'ACE (*Control Access Entry*)
- Les ACL peuvent êtres placées pour analyser le trafic entrant (*ACL Entrante*)ou sortant (*ACL Sortante*) de chaque interface.
- Une gamme d'ACL doit être déclarer pour l'IPv4 et pour l'IPv6
- Les ACE sont gérées dans l'ordre du listing de l'ACL. le traitement de l'ACE s'arrète à la première ACL qui match avec l'adresse ip du paquet analysé.
- 2 types d'ACL:
    <details>
    <summary>Standard</summary>
    
    - à placer proche de la destination du trafic à filtrer
    - ne filtrent qu'au niveau de la couche 3 en utilisant uniquement l'adresse IPv4 source
    </details>
    <details>
    <summary>Etendue</summary>

    - à placer proche de la source du trafic à filtrer
    - filtrent au niveau :
        - de la couche 3 en utilisant l'adresse IPv4 source et/ou destination
        - de la couche 4 en utilisant les ports TCP et UDP, ainsi que des informations facultatives sur le type de protocole pour un contrôle plus fin
    </details>

---
# Définition des masques de contrôle d'IP
## Gestion d'IP hôtes
- ACL type:
    ```ios
    access-list 10 permit 192.168.1.1 0.0.0.0
    ```
|                          | Décimal     | Binaire                              |
|--------------------------|-------------|--------------------------------------|
| Adresse ipv4             | 192.168.1.1 | 11000000.10101000.00000001.00000001  |
| Masque de réseau         | 0.0.0.0     | 00000000.00000000.00000000.00000000  |
| résultat d'autorisation  | 192.168.1.1 | 11000000.10101000.00000001.00000001  |
## Gestion d'IP sous-réseau
- ACL type:
    ```ios
    access-list 10 permit 192.168.1.0 0.0.0.255
    ```
|                          | Décimal        | Binaire                              |
|--------------------------|----------------|--------------------------------------|
| Adresse ipv4             | 192.168.1.1    | 11000000.10101000.00000001.00000001  |
| Masque de réseau         | 0.0.0.255      | 00000000.00000000.00000000.11111111  |
| résultat d'autorisation  | 192.168.1.0/24 | 11000000.10101000.00000001.00000000  |
## Gestion de plages d'IP
- ACL type:
    ```ios
    access-list 10 permit 192.168.16.0 0.0.15.255
    ```
|                          | Décimal        | Binaire                              |
|--------------------------|----------------|--------------------------------------|
| Adresse ipv4             | 192.168.16.0   | 11000000.10101000.00010000.00000001  |
| Masque de réseau         | 0.0.15.255      | 00000000.00000000.00001111.11111111  |
| résultat d'autorisation  | 192.168.16.0/24 à 192.168.31.0/24 | 11000000.10101000.00000000.00000000 à 11000000.10101000.000111111.00000000  |
---
# Gammes d'AC
- Les ACL standards et étendues peuvent être numérotées ou nommées.
- Si on utilise des ACL numérotées, leure type est défini par la numérotation:
    - standards: numéros 100 à 199
    - étendues: numéros 2000 à 2699
## ACL Standard
### Numérotées
```ios
access-list access-list-number {deny | permit | remark text} source [source-wildcard] [log]
```
- exemple:
    ```ios
    access-list 10 permit 192.168.10.0 0.0.0.255
    ```
|Paramètre|Descritption|
|--|--|
|access-list-number|numérotation de l'ACL (1 à 99 ou 1300 à 1999)|
|deny / permit|droits d'accès géré|
|remark|Permet d'ajouter du texte descriptif (facultatif)|
|source|adresse hôte ou réseau à gérer / mot-clé "any" cible tous les réseau / mot-clé "host" cible un hôte spécifique|
|source-wildcard|masque de la source|
|log|permet de logguer a chaque fois qu'une ACE est matchée avec un paquet|
### Nommées
- accéder au mode de configuration de l'ACL:
    ```ios
    ip access-list standard "access-list-name"
    ```
    - exemple:
        ```ios
        ip access-list standard PERMIT-ACCESS
        ```
- paramétrer l'ACL:
    ```ios
    default         remet à l'origine les paramètres de l'ACL
    deny            cible des paquets à rejeter
    exit            sort de la conf ACL
    permit          cible des paquets à autoriser
    remark          ajoute une description de l'ACL
    ```
### Application d'une ACL IPv4 standard
- Dans le mode de configuration d'une interface:
    ```ios
    ip access-group {access-list-number | access-list-name} {in | out}
    ```
    - exemple:
        ```ios
        interface Serial 0/1/0
        ip access-group PERMIT-ACCESS out
        ```    
> => pour désactiver l'ACL de l'interface "no ip access-group"
### Modification d'un ACL
#### via un éditeur de texte
- Copiez l'ACL à partir de la configuration en cours d'exécution et collez-la dans l'éditeur de texte.
- Effectuez les modifications nécessaires.
- Supprimez l'ACL précédemment configurée sur le routeur sinon, les nouvelles règles vont se cumulées aux anciennes
- Copiez et collez la liste ACL modifiée sur le routeur.
#### via les numéros de séquences
- dans le menu de configuration de l'ACL
    - supprimé le n° de séquence à corriger
    - ajouter la ligne corrigée
        ```ios
        conf t
        ip access-list standard "N° ou nom ACL à corriger"
        no "n° de séquence à corriger"
        "ACE à ajouter"
        end
        ```
    - exemple:
        ```ios
        conf t
        ip access-list standard 1
        no 10
        10 deny host 192.168.10.10
        end
        ```
### Sécurisation des accès vty avec des ACL
```ios
conf t
line vty "n° de ligne"
login local
transport input "ssh|telnet"
access-class {access-list-number | access-list-name} { in | out }
end
```
- exemple:
    ```ios
    conf t
    line vty 0 4
    transport input ssh
    access-class ADMIN-HOST in
    end
    ```  
--- 
## ACL étendues
### Numérotées
```ios
access-list access-list-number {deny | permit | remark text} protocol source source-wildcard [operator {port}] destination destination-wildcard [operator {port}] [established] [log]
```
|Paramètre|Descritption|
|--|--|
|access-list-number|numérotation de l'ACL (100 à 199 ou 2000 à 2699)|
|deny / permit|droits d'accès géré|
|remark|Permet d'ajouter du texte descriptif (facultatif)|
|protocol|nom ou numéro de protocol internet / mot-clé compatible { ip / tcp / udp / icmp }|
|source|adresse hôte ou réseau source à gérer / mot-clé "any" cible tous les réseau / mot-clé "host" cible un hôte spécifique|
|source-wildcard|masque de la source|
|destination|adresse hôte ou réseau de destination à gérer / mot-clé "any" cible tous les réseau / mot-clé "host" cible un hôte spécifique|
|destination-wildcard|masque de la destination|
|operator|compare les ports source et destination {lt / gt / neq / range}|
|port|n° ou nom d'un port tcp ou udp (facultatif)|
|established|permet au trafic intérieur de quitter le réseau privé et permet au trafic de réponse de retourner dans le réseau privé (facultatif)|
|log|permet de logguer a chaque fois qu'une ACE est matchée avec un paquet|

<details>
<summary>Listing Protocoles</summary>
    
- <0-255>: n'importe quel n° de protocol IP
- ahp: Authentication Header Protocol
- dvmrp: dvmrp
- eigrp: Cisco's EIGRP routing protocol
- esp: Encapsulation Security Payload
- gre: Cisco's GRE tunneling
- icmp: Internet Control Message Protocol
- igmp: Internet Gateway Message Protocol
- ip: tout les protocols IP
- ipinp: IP in IP tunneling
- nos: KA9Q NOS compatible IP over IP tunneling
- object-group: Service object group
- ospf: OSPF routing protocol
- pcp: Payload Compression Protocol
- pim: Protocol Independent Multicast
- tcp: Transmission Control Protocol
- udp: User Datagram Protocol
</details>
<details>
<summary>Listing Ports</summary>
    
- La sélection d'un protocole influence les options port
    - le protocole tcp fournirait des options de ports liés à TCP
    - le protocole udp fournirait des options de ports spécifiques à UDP
    - le protocole icmp fournirait des options de ports liés à ICMP
</details>

### Nommées
- accéder au mode de configuration de l'ACL:
    ```ios
    ip access-list extended "access-list-name"
    ```
    - exemple:
        ```ios
        ip access-list extended PERMIT-ACCESS
        ```
### Application d'une ACL IPv4 étendue
- Dans le mode de configuration d'une interface:
    ```ios
    ip access-group {access-list-number | access-list-name} {in | out}
    end
    ```
    - exemple:
        ```ios
        interface g0/0/0
        ip access-group PERMIT-PC1 in
        end
        ```    
> => pour désactiver l'ACL de l'interface "no ip access-group"
#### via un éditeur de texte
- Copiez l'ACL à partir de la configuration en cours d'exécution et collez-la dans l'éditeur de texte.
- Effectuez les modifications nécessaires.
- Supprimez l'ACL précédemment configurée sur le routeur sinon, les nouvelles règles vont se cumulées aux anciennes
- Copiez et collez la liste ACL modifiée sur le routeur.
#### via les numéros de séquences
- dans le menu de configuration de l'ACL
    - supprimé le n° de séquence à corriger
    - ajouter la ligne corrigée
        ```ios
        conf t
        ip access-list extended "N° ou nom ACL à corriger"
        no "n° de séquence à corriger"
        "ACE à ajouter"
        end
        ```
    - exemple:
        ```ios
        conf t
        ip access-list extended 1
        no 10
        10 deny host 192.168.10.10
        end
        ```
