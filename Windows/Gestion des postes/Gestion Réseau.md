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

# **Récupération ds informations réseau via cmd <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**

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