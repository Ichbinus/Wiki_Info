<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWm5xhiMCVZ8XEeBhHpe1UMw6g0u-707GzxQ&s" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Service DNS sur Windows Server</h1>
</div>

---
# Table des matières
- [Installation pilote](#installation-pilote)
- [Création de ports](#création-de-ports)
- [Création d’imprimantes](#création-dimprimantes)
- [Création de pool d’impression](#création-de-pool-dimpression)
---
# Prérequis
- le serveur doit appartenir au réseau ou domaine qui doit être géré
---
# Installation du rôle DNS
## Via Interface graphique
## Via Powershell
```powershell
Install-WindowsFeature -Name DNS -IncludeManagementTools 
```
---
# Gestion du rôle DNS
## Via Interface graphique
- Redirection de DNS
    - dans le cas où le DNS est sur un réseau privé et doit faire appelle à un autre DNS pour les adresses publics
    - clique droit sur le serveur DNS, propriétés
                
        ![dns_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_1.png)
                
    - redirecteur, modifier
                
        ![dns_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_2.png)
                
    - saisir l’adresse ip du dns où on veut rediriger les demandes, puis ok
                
        ![dns_3](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_3.png)
                
    - appliquez les changement et ok.
- vidange de cache DNS
    - dans le cas de modification de changement de redirection ou relance de DNS
    - clique droits sur le serveur DNS, puis effacer le cache
                
        ![dns_4](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_4.png)
                
- créer des zone de recherches (redirection de recherches texte vers des partages/adresses ip sur un réseau interne)
    - création d’un zone de recherche
        - clique droits sur “zone de recherche ”, nouvelle zone
                    
            ![dns_5](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_5.png)
                    
    - paramétrage d’une zone de recherches inversées (recherche à partir d’IP)
        - clique droits sur “zone de recherche inversée”, nouvelle zone
        - sélectionner zone principale, ipv4 ou ipv6
                    
            ![dns_6](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_6.png)
                    
        - saisir les 3 premier octets du réseau ou on souhaite faire des recherches inversées
                    
            ![dns_7](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_7.png)
                    
        - valider le fichier créé
                    
            ![dns_8](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_8.png)
                    
        - paramétrer les mise à jour et terminer
                    
            ![dns_9](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_9.png)
                    
    - création d’un hôte
        - dans la zone souhaité, clique droit puis “nouvel hôte”
                    
            ![dns_10](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_10.png)
                    
        - saisir le nom de l’hôte, sont adresse ip et cocher le pointeur d’enregistrement pour permettre une recherche inversée.
                    
            ![dns_11](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_11.png)
                    
    - création d’un alias
        - dans la zone souhaité, clique droit puis “nouvel alias”
                    
            ![dns_10](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_10.png)
                    
        - saisir le nom de l’alias, et allez chercher dans le domaine l’hôte correspondant à l’alias
            - (ex: si on cherche le dhcp, on va aller chercher le serveur sur lequel est installer le dhcp)
                    
            ![dns_12](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_12.png)
                    
- mise en place de chaine de résolution
    - mettre en place un redirecteur conditionnel, taper le nom de domaine où on veut rediriger et l’adresse ip du DNS de l’autre réseau
                
        ![dns_13](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/dns_image/dns_13.png)
## Via PowerShell  
- Configuration redirection inconditionnelle  
    ```powershell
    Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru
    ``` 
- Créer une zone Primaire
    - Zone directe
        ```powershell
        Add-DnsServerPrimaryZone -Name "nom de la zone " -ZoneFile "nomdelazone.dns"
        ```  
    - Zone Inverse      
        ```powershell
        Add-DnsServerPrimaryZone -NetworkID 85.17.209.0/24 -ZoneFile "209.17.85.in-addr.arpa.dns"
        ```
- Configuration redirecteur conditionnel
    ```powershell
    Add-DnsServerConditionalForwarderZone -Name "ad.campus-eni.fr" -MasterServers "10.0.0.3","10.35.0.3"
    ```
- Créer des enregistrements
    - types d’enregistrements
        - A : Enregistrements d’hôte ipv4
        - AAAA: Enregistrements d’hôte ipv6
        - MX : serveur mail (Mail Xchanger)
        - PTR: pointeur inverse (obtenir un nom d’hôte en fonction d’une ip)
        - CNAME : Alias d’un hôte
    - **Enregistrement A :**
        ```powershell
        Add-DnsServerResourceRecord -ZoneName "le nom de la zone" -Name "le nom du hôte" –A -IPv4Address "l’adresse IP"
        ```
    - **Enregistrement CNAME :**
        ```powershell
        Add-DnsServerResourceRecord -ZoneName "le nom de la zone" -Name "Alias de l'hôte" –CNAME -HostNameAlias "le nom du hôte originale"
        ```
    - **Enregistrement MX :**
        ```powershell
        Add-DnsServerResourceRecord -ZoneName "le nom de la zone" -Name "le nom du hôte" –MX –MailExchange "Le FQDN du serveur mail" -Preference "la priorité du serveur mail"
        ```
    - **Enregistrement PTR :**
        ```powershell
        Add-DnsServerResourceRecord -ZoneName "le nom de la zoneinverse" -Name "numéro de la machine (dernier octet de l'IP de l'hôte)" –PTR –PtrDomainName "le FQDN de l'hôte ciblé"
        ```
- Obtenir les configurations du DNS
    ```powershell
    Get-DnsServer
    ```
- Ajout d’un serveur secondaire
    - autoriser le transfert au niveau du serveur primaire
        ```powershell
        Set-DnsServerPrimaryZone "NomdeZone" -SecureSecondaries "TransferAnyServer" -Notify "Notify"
        ```
    - Ajouter le rôle DNS sur le serveur secondaire
        ```powershell
        Install-WindowsFeature DNS -IncludeManagementTools
        ```
    - la zone secondaire sur le serveur secondaire
        ```powershell
        Add-DnsServerSecondaryZone -Name "nom de la zone primaire" -ZoneFile "nom de la zone primaire .dns" -MasterServers "@IP du serveur primaire"
        ```