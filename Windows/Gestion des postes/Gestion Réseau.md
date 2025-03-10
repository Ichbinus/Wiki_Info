<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://memos.nadus.fr/wp-content/uploads/2018/05/le-partage-de-fichiers-icone-psd_30-2568.jpg" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Gestion du réseau sous Windows</h1>
</div>

# **Gestion des informations réseau via cmd <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**

## Affichage config carte réseau
- affichage simplifié config carte réseau
    ```cmd
    ipconfig
    ```
- Toutes les infos
    ```cmd
    Ipconfig /all
    ```  
- Afficher le cache DNS
    ```cmd
    ipconfig /displaydns
    ```
- Connaitre la connectivité entre 2 machines
    ```cmd
    Ping xxx.xxx.xxx.xxx (@ip)
    ```
    > 💡 Attention, un pare-feu peu bloquer le protocole du ping (ICMP) (blocage de tous les flux entrants)  
- Afficher les ports tcp/udp
    ```cmd
    netstat -a
    ``` 
- Afficher la table de routage 
    ```cmd
    netstat -r
    ```
- afficher des routeurs sur un chemin ping
    ```cmd
    tracert xxx.xxx.xxx.xxx (@ip)
    ```
    > 💡 Idem que ping mais donne les routeurs traversés en plus, ça permet d'identifier un point de blocage dans un souci de connexion.    
    
---
## Dépannage Réseau
- Vider le cache DNS
    ```cmd
    ipconfig /flushdns
    ```
- Renouvellement de bail (bail=>attribution config ip par DHCP)
    ```cmd
    ipconfig /renew
    ```
- Libération de bail
    ```cmd
    ipconfig /release
    ```
---
---
# **Gestion des informations réseau via PowerShell <img src="https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png" height="50px" />**
## **Récupération des informations réseau**
### Affichage de la configuration des cartes réseau
- Affichage simplifié de la configuration réseau :
  ```powershell
  Get-NetIPConfiguration
  ```
- Affichage complet des informations :
  ```powershell
  Get-NetAdapter | Format-List *
  ```
- Afficher le cache DNS :
  ```powershell
  Get-DnsClientCache
  ```
### Tester la connectivité entre deux machines
- Vérifier la connectivité avec une adresse IP :
  ```powershell
  Test-Connection -ComputerName xxx.xxx.xxx.xxx -Count 4
  ```
  > 💡 Attention, un pare-feu peut bloquer le protocole ICMP.
- Afficher les connexions réseau actives (ports TCP/UDP) :
  ```powershell
  Get-NetTCPConnection
  ```
- Afficher la table de routage :
  ```powershell
  Get-NetRoute
  ```
- Afficher les routeurs traversés sur un chemin réseau :
  ```powershell
  Test-NetConnection -TraceRoute -ComputerName xxx.xxx.xxx.xxx
  ```
  > 💡 Permet d'identifier un point de blocage dans un souci de connexion.
---

## **Dépannage Réseau**

### Gestion du cache DNS

- Vider le cache DNS :
  ```powershell
  Clear-DnsClientCache
  ```

### Gestion de l'adresse IP et du DHCP

- Renouveler le bail DHCP :

  ```powershell
  ipconfig /renew  # Pas encore d'équivalent natif en PowerShell
  ```

- Libérer le bail DHCP :

  ```powershell
  ipconfig /release  # Pas encore d'équivalent natif en PowerShell
  ```

---

## **Gestion des interfaces réseau**

- Lister toutes les interfaces réseau :
  ```powershell
  Get-NetAdapter
  ```
- Désactiver une interface réseau :
  ```powershell
  Disable-NetAdapter -Name "NomDeL'Interface" -Confirm:$false
  ```
- Activer une interface réseau :
  ```powershell
  Enable-NetAdapter -Name "NomDeL'Interface"
  ```

## **Gestion des adresses IP et de la passerelle**

- Afficher l'adresse IP actuelle :
  ```powershell
  Get-NetIPAddress
  ```
- Modifier l'adresse IP manuellement :
  ```powershell
  New-NetIPAddress -InterfaceAlias "NomDeL'Interface" -IPAddress "192.168.1.100" -PrefixLength 24 -DefaultGateway "192.168.1.1"
  ```

## **Affichage et gestion des règles de pare-feu**

- Lister les règles du pare-feu Windows :
  ```powershell
  Get-NetFirewallRule
  ```
- Ajouter une règle pour autoriser le ping (ICMP) :
  ```powershell
  New-NetFirewallRule -DisplayName "Autoriser Ping" -Direction Inbound -Protocol ICMPv4 -Action Allow
  ```
- Désactiver temporairement le pare-feu (⚠️ à utiliser avec prudence) :
  ```powershell
  Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
  ```

## **Résolution DNS et connectivité avancée**

- Tester la résolution d’un nom de domaine :
  ```powershell
  Resolve-DnsName google.com
  ```
- Vérifier la connectivité avec une machine distante sur un port spécifique :
  ```powershell
  Test-NetConnection -ComputerName google.com -Port 443
  ```

