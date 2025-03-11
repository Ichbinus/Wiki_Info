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

<aside>
⚠️ Les programmes à publier doivent être installer sur le serveur procédant à la publication

</aside>

- Dans la collection souhaité
    - cliquer sur ***tache*** de remoteapp, puis publier des programmes  
    ![ ](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/src/branch/gestion_wind_serv_rdp/Windows/Gestion%20serveurs/images/pub_app_1.png)
        
    - suivre l’assistant pour choisir l’app à publier.
        - cocher les app à publier, puis suivants, suivants,…
        
        ![pub_app_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/src/branch/gestion_wind_serv_rdp/Windows/Gestion%20serveurs/images/pub_app_2.png)
        
        > N.B: on peux ajouter un programme non listé en cliquant sur “ajouter”


## Configuration des applications

- Depuis les propriétés de la collection pour agir sur plusieurs programmes en même temps.
- Depuis les propriétés de publication du programme pour agir programme par programme
    
    ![Untitled](Untitled%202.png)
    

# Accès aux application à distance

## Client web

<aside>
⚠️ Le service Accès Bureau à distance par le web (RDS-Web-Access) doit être installé, il s’appuie sur IIS pour son fonctionnement

</aside>

- Depuis un navigateur via le portail Accès Bureau à distance par le Web (RD Web Access)
    - https://nom_du_serveur/RDWeb
    - Une fois authentifié, l’utilisateur peut ensuite lancer l’application souhaitée
    
    ![Untitled](Untitled%203.png)
    

## outils RemoteApp

<aside>
⚠️ Attention pour ce que cela soit fonctionnel, le certificat serveur doit avoir été déployé sur le client

⇒ création d’un PKI

⇒ génération de clé privée/publique

⇒ partage de clé public

</aside>

- Accéder aux programmes RemoteApp et aux services Bureau à distance
    - Saisir l’url de connection dans l’outils
        - https://nom_FQDN_du_serveur/RDWeb/Feed/webfeed.aspx
        
        ![Untitled](Untitled%204.png)
        
    - Les raccourcis RemoteApp apparaissent dans un répertoire Work Resources dans le menu Démarrer