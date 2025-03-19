<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Configuration traduction NAT sur les routeurs CISCO</h1>
</div>

---
# Table des matières
- [Avantage / Inconvénient de NAT](#versions-de-snmp)
- [NAT Statique](#nat-statique)
- [NAT Dynamique](#nat-dynamique)
- [PAT (Traduction d’adresses de port)](#pat-traduction-dadresses-de-port)

---
# Avantage / Inconvénient de NAT
  <details>
  <summary>Avantages</summary>

  - Plusieurs hôtes internes peuvent partager une même adresse IPv4 publique pour toutes leurs communications externes
  - Fonction NAT augmente la souplesse des connexions au réseau public
  - Assure la cohérence des schémas d’adressage du réseau interne, même en cas de modification du réseau d'adressage public
  - En utilisant les adresses IPv4 de la RFC 1918, la NAT cache les adresses IPv4 des utilisateurs et autres périphériques
  </details>
  <details>
  <summary>Inconvénients</summary>

  - Impact sur les performances du réseau, en particulier pour les protocoles en temps réel tels que la voix sur IP. La fonction NAT augmente les délais de transfert, car la traduction de chaque adresse IPv4 des en-têtes de paquet prend du temps
  -  l'utilisation de la NAT provoque la perte de l'adressage de bout en bout. Donc certaines applications ne sont pas compatibles avec la NAT
  - La traçabilité IPv4 de bout en bout est également perdue
  - L’utilisation de la fonction NAT complique également l’utilisation des protocoles de tunneling, tels qu’IPsec, car la NAT modifie les valeurs dans les en-têtes, provoquant ainsi l’échec des vérifications d’intégrité
  </details>

# NAT Statique
## Mise en place du NAT statique
- Crétion d'un mappage entre les adresses locales internes et les adresses globales internes
  ```ios
  conf t
  ip nat inside source static "adresse IP réelle du poste" "adresse de traduction à destination du réseau public"
  ```
  - exemple: 
    ```ios
    conf t
    ip nat inside source static 192.168.10.254 209.165.201.5
    ```
- Configuration des interfaces participant à la traduction comme étant internes ou externes par rapport à la NAT
  ```ios
  interface "id interface interne du réseau"
  ip address "ip interface interne du réseau" "masque adresse IP"
  ip nat inside
  exit
  interface "id interface externe du réseau"
  ip address "ip interface externe du réseau" "masque adresse IP"
  ip nat outside
  exit
  ```
  - exemple: 
    ```ios
    interface serial 0/1/0
    ip address 192.168.1.2 255.255.255.252
    ip nat inside
    exit
    interface serial 0/1/1
    ip address 209.165.200.1 255.255.255.252
    ip nat outside
    exit
    ```
## Vérification du NAT statique
- Afficher les traductions NAT actives
  ```ios
  show ip nat translations
  ```
- Afficher des informations sur le nombre total de traductions actives
  ```ios
  show ip nat statistics
  ```
# NAT Dynamique
## Mise en place NAT dynamique
- Définissez le pool d'adresses à utiliser pour la traduction
  ```ios
  conf t
  ip nat pool "nom du pool" "étendue IP externe => ip-début ip-fin" netmask "netmask des IP externe"
  ```
  - exemple:
    ```ios
    conf t
    ip nat pool NAT-POOL1 209.165.200.226 209.165.200.240 netmask 255.255.255.224
    ```
- Configurer une liste de contrôle d'accès (ACL) standard pour identifier (autoriser) uniquement les adresses qui doivent être traduites
  ```ios
  conf t
  access-list "n° ou nom ACL" permit "IP du poste ou réseau à traduire" "wildmask du poste ou réseau à traduire"
  ```
  - exemple:
    ```ios
    conf t
    access-list 1 permit 192.168.0.0 0.0.255.255
    ```
- Lier l'ACL au pool
  ```ios
  conf t
  ip nat inside source list { access-list-number | access-list-name} pool "nom du pool"
  ```
  - exemple:
    ```ios
    conf t
    ip nat inside source list 1 pool NAT-POOL1
    ```
- Identifier les interfaces internes et externe du point de vue de la NAT
  ```ios
  conf t
  interface "id interface réseau interne"
  ip nat inside
  Interface "id interface réseau externe"
  ip nat outside
  ```
  - exemple:
    ```ios
    conf t
    interface serial 0/0/0
    ip nat inside
    interface serial 0/1/0
    ip nat outside
    ```
## option du NAt dynamique
- Par défaut, les entrées de traduction expirent au bout de 24 heures. Pour modifier ce délai:
  ```ios
  ip nat translation timeout timeout-seconds
  ```
- Effacer les entrées dynamiques avant l’expiration du délai:
  - effacer toutes les traductions dynamiques:
    ```ios
    clear ip nat translation *
    ```
  - Effacer une traductions dynamique simple: 
    - interne vers externe:
      ```ios
      clear ip nat translation inside "global-ip" "local-ip"
      ```
    - externe vers interne:
      ```ios
      clear ip nat translation outside "local-ip" "global-ip" 
      ```
  - Effacer une traductions dynamique étendue:
    - interne vers externe:
      ```ios
      clear ip nat translation "protocol" inside "global-ip" "global-port" "local-ip" "local-port"
      ```
    - externe vers interne:
      ```ios
      clear ip nat translation "protocol" outside "local-ip" "local-port" "global-ip" "global-port"
      ```
## Vérification de la NAT dynamique
- Afficher les traductions NAT actives
  ```ios
  show ip nat translations
  ```
>On peut ajouter le mot-clé verbose pour obtenir plus d'informations (ex: date de création et la durée d'utilisation d'une entrée)
- Afficher des informations sur le nombre total de traductions actives
  ```ios
  show ip nat statistics
  ```
# PAT (Traduction d’adresses de port)
## Mise en place PAT
- PAT correspond à une option du NAT dynamique.
- Au moment de l'association de l'ACL au pool d'adresses externes, il faut ajouter le mot-clé "overload"
- Lier l'ACL au pool en mode PAT
  ```ios
  conf t
  ip nat inside source list { access-list-number | access-list-name} pool "nom du pool" overload
  ```
  - exemple:
    ```ios
    ip nat inside source list 1 pool NAT-POOL2 overload
    ```
