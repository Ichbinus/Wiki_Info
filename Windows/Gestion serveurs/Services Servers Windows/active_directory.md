<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://i.imgur.com/NNAJbnO.png" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Active directory</h1>
</div>

---
# Installation de l'Active Directory
## Prérequis
- Un compte administrateur.
- Une adresse IP statique configurée sur le serveur.
- Un nom d'hôte configuré correctement.
## Installation via interface graphique

## Installation via powershell
### Installation du Rôle
- Ouvrez PowerShell en tant qu'administrateur et exécutez la commande suivante :
    ```powershell
    Get-windowsfeature AD
    Install-WindowsFeature AD-Domain-Services -IncludeAllSubfeature -IncludeManagementTools
    ```
    >📌Cette commande installe le rôle Active Directory Domain Services (AD DS) ainsi que les outils de gestion associés.
### Promotion du serveur en contrôleur de domaine
- Une fois le rôle installé, vous devez promouvoir le serveur en tant que contrôleur de domaine. S cas possibles:
   <details>
    <summary>Création d’un nouveau domaine dans une nouvelle forêt</summary>
    
   ```powershell
   Install-ADDSForest -DomainName "mondomaine.local" -domainmode default -DomainNetbiosName "MONDOMAINE" -installDNS -forestmode defauts -SafeModeAdministratorPassword (ConvertTo-SecureString "VotreMotDePasse" -AsPlainText -Force) -Force
    ```
    >📌 Explication des paramètres :
    >- DomainName → Nom du domaine (ex : mondomaine.local).
    >- DomainNetbiosName → Nom NetBIOS du domaine.
    >- SafeModeAdministratorPassword → Mot de passe pour le mode restauration (DSRM).
    >- Force → Pour exécuter la commande sans confirmation.
   </details>
      <details>
    <summary>Ajout d'un contrôleur à un domaine existant</summary>
    
    ```powershell
    Install-ADDSDomainController -DomainName "mondomaine.local" -Credential (Get-Credential) -SafeModeAdministratorPassword (ConvertTo-SecureString "VotreMotDePasse" -AsPlainText -Force) -Force
    ```
    >📌 Cela vous demandera des identifiants d'un administrateur du domaine.
   </details>
### Redémarrage du serveur
- Une fois la promotion terminée, le serveur redémarrera automatiquement.
---
# Gestion de l'Active Directory
## Administration de l'Active Directory
### Via Powershell
- création d’un nouveau site
    
    ```powershell
    New-ADReplicationSite -Identity "Nom_du_site"
    ```
    
- création d’un nouveau liens de réplication entre 2 contrôleurs de domaine
    
    ```powershell
    New-ADReplicationSiteLink "nom_du_liens" -SitesIncluded site1,site2 -Cost "poids_réplication" -ReplicationFrequencyInMinutes XX
    ```
    
- création d’un sous-réseau pour un site
    
    ```powershell
    New-ADReplicationsubnet -Name "adresse réseau" -Site "site_souhaité" -Description "quoi_qu_es_ce_qu_on_veux"
    ```
    
- Basculer un CD entre 2 site
    
    ```powershell
    $CDX => contrôleur de domaine X
    $CD3 = Get-ADDomaineControleur CD3
    $CD3|Move-ADDirectoryServer -Site "site_souhaité"
    ```
    
- Test réplication entre 2 contrôleurs de domaine
    
    ```powershell
    Get-ADReplicationConnection -Filter *   => liste les réplications entre les contrôleurs de domaine
    ```
## Gestion des éléments de l'Active Directory 
### Création des UO (Unité d’Organisation)     
#### Via interface graphique
>💡 Les UO sont une structure au sein du contrôleur de domaine qui permettra de retrouver tous les éléments du parc (machines, imprimantes, users,…)
         
- Dans la console ”utilisateur et ordinateur Active Directory”, sélectionner le dossier au sein duquel on veut créer une UO, puis cliquer sur nouvelle UO
    ![AD_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_1.png)
            
### Création des Utilisateurs (**A**GDLP)
#### Via interface graphique
    - Création de modèle d’utilisateur en fonction des spécificité de service, gestion de mot de passe, appartenance de groupes, horaires de compte,…)
            
        ![AD_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_2.png)
            
        ![AD_3](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_3.png)
            
        ![AD_4](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_4.png)
            
    - les nouveaux compte seront créé en copiant les modèles correspondants et bénéficierons des préréglage du modèle.
### Création des Groupes (globaux et Domaine Locaux)  (A**GDL**P)       
#### Via interface graphique
> 💡**Groupes Globaux**: servent à ranger les users en groupes de même caractéristiques (toutes les secrétaires du service info, tous les opérateurs du service production,…)
        
> 💡**Groupes de Domaine Local**: permet d’attribuer les droits d’accès à des ressources (fichier, imprimante,…) à des groupes globaux.
        
- depuis l’UO où on va ranger les groupes, cliquer sur “nouveau groupe”, on peux choisir groupe global ou domaine local à ce niveau
            
    ![AD_5](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_5.png)
            
### Gestion des droits et permissions d’accès (AGDL**P**)      
#### Via interface graphique
>💡 Les droits d’accès se gèrent en ajoutant sur les resources les domaines locaux dans l’onglet sécurité
        
- pour une ressource, on va créer systématiquement les domaines locaux qui correspondent aux niveau d’autorisation:
            
    ![AD_6](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_6.png)
            
    - CT: Contrôle Total
    - L: Lecture
    - M: Modification
    - R: Refus
- Sur la ressource (sur le serveur / machine), on va ajouter dans l’onglet sécurité les DL, auxquelles on va attribuer les droits/refus correspondants.
            
    ![AD_7](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_7.png)

### Gestion des GPO
#### Via interface graphique
> Disponible via l’outils de gestion des stratégies de groupes via l'application : gpmc.msc
- Création d’un stratégie
    - clique droit sur une UO du domaine pour créer un GPO à cet endroits (et à tous ceux en dessous, #héritage)
        
        ![AD_8](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_8.png)
        
    - sélectionner le type de gpo  (ordi/utilisateur)
    - saisir les paramètres à appliquer
    - valider la politique
- appliquer un nouvelle GPO
    - sur le poste clients:
        ```cmd
        gpupdate /force
        ```
#### Top Tier GPO à mettre en place
<details>
<summary>Administrateurs local</summary>
    
- A partir de la console "Gestion de stratégie de groupe", créez une nouvelle stratégie de groupe qui devra être liée à l'OU qui contient vos postes de travail. Bien sûr, vous pouvez lier la GPO à plusieurs OUs... Pour ma part, l'OU "PC" est ciblée et la GPO s'appelle "Sécurité - Ordinateurs - Admins locaux".
    ![AD_9](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_9.png)
- Lorsque l'objet GPO est créé, effectuez un clic droit dessus puis "**Modifier**" pour commencer le paramétrage.
- Parcourez les paramètres de cette façon :
    ```
    Configuration ordinateur > Préférences > Paramètres du Panneau de configuration > Utilisateurs et groupes locaux
    ```
- Sur la partie de droite, effectuez un clic droit et sous "Nouveau", cliquez sur "Groupe local".
    ![AD_10](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_10.png)
- Une fenêtre s'affiche et elle va nous permettre de configurer par GPO les membres du groupe "**Administrateurs**" de nos machines. C'est pour cette raison que l'on va indiquer "**Administrateurs**" comme "**Nom du groupe**". 
    > sur un OS anglais, il faudra préciser "**Administrators**".
- Il faudra veiller à choisir l'action "**Mettre à jour**" de façon à actualiser le contenu de notre groupe de sécurité qui est déjà existant sur les machines.
- Ensuite, vous pouvez **cocher les deux options suivantes pour que le groupe de sécurité "Administrateurs" soit géré uniquement par GPO**. Cela signifie que si un utilisateur ou un groupe est ajouté à la main sur un poste, ce sera écrasé lorsque la GPO va se réappliquer !
    - Supprimer les utilisateurs
    - Supprimer les groupes
    ![AD_11](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_11.png)
- Une fois que cette première partie est effectuée, cliquez sur le bouton ***Ajouter...*** pour ajouter un nouveau membre au groupe **Administrateurs**. Choisissez bien l'action ***Ajouter à ce groupe*** et indiquez **Administrateurs** pour que le compte administrateur intégré par défaut à Windows reste membre de ce groupe. Si vous utilisez un autre nom pour le compte administrateur, adaptez cette valeur en conséquence.
    ![AD_12](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_12.png)
- **Répétez l'opération** afin d'ajouter le groupe spécifique de votre domaine Active Directory, à savoir "**IT-Connect\GDL-Admins-PC**" en ce qui me concerne.
- Ce qui donne ce résultat :
    ![AD_13](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/active_directory_image/AD_13.png)

</details>