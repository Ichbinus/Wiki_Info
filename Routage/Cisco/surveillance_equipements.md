<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.iconscout.com/icon/free/png-512/free-cisco-logo-icon-download-in-svg-png-gif-file-formats--anyconnect-brand-logos-pack-icons-1579764.png?f=webp&w=256" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Suprevision chez CISCO</h1>
</div>

---
# Versions de SNMP
Cisco prend en charge plusieurs versions de SNMP :
- **SNMPv1** : Version la plus ancienne, peu sécurisée.
- **SNMPv2c** : Ajoute le support du comptage 64 bits, mais reste basé sur une communauté non sécurisée.
- **SNMPv3** : Version la plus sécurisée avec authentification et chiffrement.
# Configuration de SNMP
## Activer SNMPv2c
- Pour activer SNMPv2c avec une communauté de lecture seule :
    ```ios
    Router(config)# snmp-server community PUBLIC ro
    ```
- Pour une communauté avec des droits en lecture et écriture :
    ```ios
    Router(config)# snmp-server community PRIVATE rw
    ```
## Activer SNMPv3
- SNMPv3 nécessite une configuration plus avancée avec authentification et chiffrement :
     ```ios
     Router(config)# snmp-server group SECUREGROUP v3 priv
     Router(config)# snmp-server user ADMIN SECUREGROUP v3 auth sha secretpass priv aes 128 secretkey
     ```
- Explication :
    - `SECUREGROUP` : Nom du groupe SNMPv3.
    - `ADMIN` : Nom de l'utilisateur SNMP.
    - `auth sha secretpass` : Utilisation de SHA pour l'authentification avec un mot de passe.
    - `priv aes 128 secretkey` : Chiffrement des données avec AES-128.
# Vérification de la configuration SNMP
## Vérifier les communautés SNMP
```ios
Router# show snmp community
```
## Vérifier les utilisateurs SNMPv3
```ios
Router# show snmp user
```
## Vérifier l'état général de SNMP
```ios
Router# show snmp
```
# Sécurisation de SNMP
- **Utiliser SNMPv3** au lieu de SNMPv1 ou SNMPv2c.
- **Limiter les accès SNMP à certaines adresses IP** :
  ```ios
  Router(config)# snmp-server community PUBLIC ro 10
  ```
  Cela restreint l'accès aux adresses définies dans l'ACL *10*.
- **Désactiver les versions SNMP non sécurisées** si elles ne sont pas nécessaires.


