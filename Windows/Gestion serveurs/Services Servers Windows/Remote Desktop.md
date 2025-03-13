<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://play-lh.googleusercontent.com/Nn5OzrekbafVDffAGtd_PIivfJCYKJQh9LvQgN8N5kQtLFTwcSh2czK8SmlOnjneaNw" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Remote Desktop Protocol (RDP)</h1>
</div>

---
# Prérequis

- Active Directory pour la gestion centralisée des utilisateurs et ressources
    - liens vers la fiche de mise en place d'un active directory
- DNS pour la résolution des noms en adresses IP
    - liens vers la fiche de mise en place d'un dns
- DHCP pour la fourniture d’adresses IP
    - liens vers la fiche de mise en place d'un dhcp
---
# Principe de fonctionnement

- installation des logiciels métiers, etc en central sur un serveur
- accès à ces applications depuis les clients légers via remote app
---
# Avantage / Désavantage
   <details>
    <summary>Avantage</summary>
    
   - **Réduction des coûts** d’acquisition du matériel et de maintenance, et de consommation énergétique
    - **Amélioration de la qualité de service**, car simplification du support et du déploiement
   - **Réponse à des contraintes spécifiques**: desserte réseau limitée, milieux hostiles
   - **Accroitre la sécurité** de l’infrastructure en limitant les données locales et la propagation des virus
   </details>
   <details>
    <summary>Désavantage</summary>
    
   - **Augmentation de la criticité des serveurs**. L’incidence de l’indisponibilité de serveurs peut être accrue.
   - **Dépendance à la qualité du réseau** (disponibilité et fiablilité)
   </details>

---
# Installation du rôle RDS
## Rôle à ajouter:

- [ ] Services bureau à distance

## Service du Rôle à installer:

- [ ] Remote desktop Connection Broker
- [ ] Remote Desktop licensing
- [ ] Remote Desktop Session Host
- [ ] Remote Desktop Web access

## Paramétrage de base: 

- [ ] Ajouter le serveur au réseau cible
- [ ] L’intégrer au domaine

---
# Mise à disposition application à distance

## Création de collection

- dans l’outils de gestion RDS
    - clique droit sur les collections et crée nouvelle collection

## Configuration de collection

- La configuration globale des applications publiées est accessible depuis les propriétés de la collection
    - Les utilisateurs autorisés
    - Les paramètres de session
    - Les paramètres de connexion
    - Les disques de profil utilisateur ⇒ pour les utilisateur nomade (pas fixés à une machine)

## Publication d’application
>⚠️ Les programmes à publier doivent être installer sur le serveur procédant à la publication


- Dans la collection souhaité
    - cliquer sur ***tache*** de remoteapp, puis publier des programmes  
        ![pub_app_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Remote_Desktop_images/pub_app_1.png)  
    - suivre l’assistant pour choisir l’app à publier.
        - cocher les app à publier, puis suivants, suivants,…
        
        ![pub_app_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Remote_Desktop_images/pub_app_2.png)
        
        > N.B: on peux ajouter un programme non listé en cliquant sur “ajouter”


## Configuration des applications

- Depuis les propriétés de la collection pour agir sur plusieurs programmes en même temps.
- Depuis les propriétés de publication du programme pour agir programme par programme
    
    ![config_app](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Remote_Desktop_images/config_app.png)
    
---
# Accès aux application à distance
## Client web
⚠️ Le service Accès Bureau à distance par le web (RDS-Web-Access) doit être installé, il s’appuie sur IIS pour son fonctionnement

- Depuis un navigateur via le portail Accès Bureau à distance par le Web (RD Web Access)
    - https://nom_du_serveur/RDWeb
    - Une fois authentifié, l’utilisateur peut ensuite lancer l’application souhaitée
    
    ![client_web](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Remote_Desktop_images/client_web.png)
    

## Outils RemoteApp
>⚠️ Attention pour ce que cela soit fonctionnel, le certificat serveur qui fournit les remotes apps doit avoir été déployé sur le client
>- **🖥️ Gestion des certificats Windows** ➡️ [`Gestion des certificats Windows/`](Gestion des certificats Windows/)

- Accéder aux programmes RemoteApp et aux services Bureau à distance
    - Saisir l’url de connexion dans l’outil
        - https://nom_FQDN_du_serveur/RDWeb/Feed/webfeed.aspx
        
        ![outils_remoteApp](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Remote_Desktop_images/outils_remoteApp.png)
        
    - Les raccourcis RemoteApp apparaissent dans un répertoire Work Resources dans le menu Démarrer