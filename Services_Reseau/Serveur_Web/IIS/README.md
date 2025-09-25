<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://i0.wp.com/www.eshop-promotion.com/wp-content/uploads/2022/06/microsoft_iis-640x250-1.png?fit=640%2C250&ssl=1" height="200px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Serveurs Web IIS</h1>
</div>

---
# Installation du service IIS

![en construction](/enconstruction.png) 

# Création de sites

- Créer un répertoire de stockage global
- Créer un répertoire individuel par site
- Dans l’outils IIS du serveur
    - Ajoutez un site Web
        
        ![picture 0](images/74419496e681f8e043eff73cc4a67d72ec386ee04bbbadc7cf80972295a2fd41.png)  
        
    - Définissez le site
        1. Donnez un nom au site
        2. Définissez le chemin d’accès au site (local ou UNC)
        3. Indiquez une @IP si le site est accessible par une @IP spécifique
        4. Indiquez le port si le site est accessible par un port spécifique
        5. Indiquez un FQDN si le site est accessible par un nom spécifique
        
        ![picture 1](images/ef66f476f0a5c936f97ff55370a28168be7c09f72e6ddd29f366f56c64882603.png)  
        
    - Création du fichier de démarrage du site (pour test du site)
        - créer un fichier index.html.txt
        - supprimer de.txt pour le rendre lisible pour un site

# Sécurisation de la connexion

- Générer un certificat auto-signé (⇒ pas ouf en terme sécu)
    - Création à partir de la configuration global
        - Certificats de serveur
            - Créer un certificat auto-signé
                
                ![picture 2](images/6619fec0a03ac85d33b428d87392c4101b47c6f04ad2fd29ebdb40503c78d4c9.png)  
                
            - Indiquer le nom du site (www.site.domaine)
            - Magasin de certificats (Hébergement web)
                
                ![picture 3](images/9ad6261a63d1e8e71c8e793a402f8f86bfe7ddfe3d5e3869eef99615d49350da.png)  
                
- Générer un certificat via autorité de certification ⇒ pki
    - Installer un PKI (Private Key Infrastructure)
        - Installer le rôle
            - Rôle à installer: “Service de certificat Active Directory”
            
            ![picture 4](images/ca62372f8a9248a71bf1da5f373fb7488440b0c53af80384108c18d69ead7c7a.png)  
            
            - Choisir les services du rôle à installer
                
                ![picture 5](images/65fc56ee0299990201421803313e70fc886e23f2455b314fbe68f70bdf8e8031.png)  
                
            - Effectuer l’installation
        - Configuration post-déploiement
            - Configurer les services de certificats
                - Vérifier le compte de l’administrateur
                    
                    ![picture 6](images/c18c6d43cd680b8a63363865845ebca1463b7cc28852db2db68d1270347c2ee9.png)  
                    
                - Sélectionner les rôles à configurer
                    
                    ![picture 7](images/1ab957d4019df78be594a01fc34adc81f929da40a82067d5b5a9309e64ef07f0.png)  
                    
                - Spécifier le type d’installation
                    
                    ![picture 8](images/ed49884dd6641dff6e59180eda412a9f4f656c7de4a8e4f17b729e1a540312e4.png)  
                    
                - Spécifier le type de l’AC
                    
                    ![picture 9](images/0b09f8e8922517e13d69e90e83121f1fcca3f6a31d845d6614ca55593d5d9176.png)  
                    
                - Spécifier le type de la clé privée
                    
                    ![picture 10](images/8476c52d61503175ddacbb07443668a51deaf3edb1d42694c3e0b749dcf7a0d4.png)  
                    
                - Spécifier le chiffrement à utiliser
                    
                    ![picture 11](images/35e9e1ada06b9fe4baa50c1f3ef268516f0d1d49a9cbf1fdf70d842981ff3d89.png)  
                    
                - Spécifier le nom de l’AC
                    
                    ![picture 12](images/37b641b08576f91556d9752230171ed6b5c55b29750dfe7ac5cdba9a6fa94e9c.png)  
                    
                - Spécifier la période de validité
                    
                    ![picture 13](images/20253579719250ce4c6fcc3ee15c7842c74c4b7c509047703b97e2d5a6882107.png)  
                    
                - Contrôler le résumé de l’installation
                - Installation terminée
    - Consultation certificat du serveur ⇒ sur serveur gérant les certificats
        - Dans la console “autorité de certification:
            - clique droit sur le serveur
            - propriété
            - afficher le certificat
                
                ![picture 14](images/642c38a49cbd1ed820a607857dbbfb9be25e486de5ea5257381cdd8559d45370.png)  
                
    - Création de modèle de certificat IIS ⇒ sur serveur gérant les certificats
        - Dans la console “autorité de certification:
            - clique droit sur l’UO “Modèle de certificat”
            - Gérer
            - Clique droits dupliquer le template de certificat souhaité
                
                ![picture 15](images/4dc44058e0caa6311084195b6b10967e84d9162bcf0b4806446cf70f15f7b56c.png)  
                
            - Onglet Compatibilité
                - Choisir l’autorité de certification et le destinataire du certificat en fonction des données réelles
            - Onglet Général
                - saisir le nom complet du modèle
                
                >⚠️ Bonne pratique ⇒ ça doit être le nom du site
                
                - Cocher la publication dans l’AD si un active directory gère le SI.
            - Onglet Sécurité
                - définir les utilisateur (ou groupe d’utilisateur) qui à des droits sur le certificat.
                - si géré par AD, ajouter le serveur/ordinateur qui devra faire les requêtes de certificat
    - Publication du modèle ⇒ sur serveur gérant les certificats
        - Dans la console “autorité de certification:
            - clique droit sur l’UO “Modèle de certificat”
            - Nouveau
                - Modèle de certificat à délivrer
            - sélectionner le modèle de certificat souhaité
            - valider
    - Installation du certificat ⇒ sur serveur gérant le site
        - Dans console certlm.msc
            - Personnel
                - Clic droit
                    - Toutes les tâches
                        - Demander un nouveau certificat
            - Si intégrant un active directory
                - séléctionner la stratégie AD
                    - suivant
                - Sélectionner le certificat souhaité
                - Configurer les paramètres
            - configurer les informations supplémentaires
                - onglet objet
                    - Nom du sujet
                    - Nom commun (FQDN du site)
                    - DNS ⇒ important pour que le certificat soit reconnu sur les new explorateurs
                        
                        ![picture 16](images/395b2f04be14b94fcc8855bb58349f8a6b9925ffe3d353021d0361f3b2431856.png)  
                        
                - onglet général
                    - Nom convivial
                    - Description
            - Valider les informations
            - Lancer l’inscription
        - Vérification présence certificat
            - Dans console certlm.msc
                - dérouler l’UO “personnel” il doit être lister dedans.
- Mise en place certificat sur le site
    - sur le site souhaité ⇒ sur serveur gérant le site
        - dans le menus des liaisons du site
        - créer une liaison en https (ou modifier une existante)
        - mettre le port souhaité (défauts 443 pour https)
        - saisir le FQDN en nom d’hôte
        - sélectionner le certificat créé précédemment
            
            ![picture 17](images/f1989ec2946829b3e28fa573857d4df3650f328c82196db1ef2554745e5c34fc.png)  
            
        - redémarrer le site