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
# Application d'une ACL IPv4
- Dans le mode de configuration d'une interface:
    ```ios
    ip access-group {access-list-number | access-list-name} {in | out}
    ```
    - exemple:
        ```ios
        interface Serial 0/1/0
        ip access-group PERMIT-ACCESS out
        ```    
> pour désactiver l'ACL de l'interface "no ip access-group"
