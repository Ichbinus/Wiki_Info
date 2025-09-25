  <p align="center">
    <a href="#">
      <img src="https://upload.wikimedia.org/wikipedia/commons/1/10/Apache_HTTP_server_logo_%282019-present%29.svg" height="200px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Serveurs Web Apache</h1>
</div>

---
# Création de site

- Installation du paquet apache
    
    ```bash
    apt install apache2
    ```
    
- création du fichier de configuration du site /etc/apache2/site-available/<nom.du.site>.conf
    - copier le fichier de conf par défaut
        
        ```bash
        cp 000-default.conf <nom.du.site>.conf
        ```
        
    - modifier selon les spécificités du site souhaité
        
        ```bash
        <VirtualHost *:80>
                        DocumentRoot /var/www/<nom.du.site>
                        ServerName <nom.du.site>
                        <directory /var/www/<nom.du.site>>
                                    Options MultiViews FollowSymlinks
                                    AllowOverride None
                                    Require all granted
                        </directory>
        </VirtualHost>
        ```
        
        - structure du fichier de conf:
            - Définition de l’hôte virtuel
                
                ```bash
                • Balise ouverture: <Virtualhost …>
                • Balise de fermeture : </Virtualhost>
                
                paramètres de balise d'ouverture:
                    <Virtualhost *:80>
                        - * : accessible par toutes les adresses IP locales (remplaçable par une adresse IPv4 ou IPv6 ou un FQDN
                        - 80: numéro de port => * pour tous les ports
                ```
                
            - Répertoire contenant les donnés du site
                
                ```bash
                Directive : « DocumentRoot »
                • Chemin par défaut : « /var/www/<nom.du.site> »
                ```
                
            - Les sections de configuration
                - gérer les accès à des éléments de l’arborescence du site
                    
                    ```bash
                    Section « <Directory> » et « </Directory> » : pour un répertoire
                    Section « <Files> » et « </Files> » : pour un fichier quelque soit sont emplacement
                    ```
                    
                - gérer les accès à des éléments hors de l’arborescence du site
                    
                    ```bash
                    Section « <Location> » et « </location> » : pour gérer l’accès à des éléments utilisé par le site Web (Base de données)
                    ```
                    
            - Ordre lecture des sections de configuration
                - Les sections sont traitées dans l’ordre où elles apparaissent
                    - <Directory> » et « </Directory>
                        - Ces sections sont traitées du répertoire avec le chemin le plus court au plus long
                        - Si plusieurs sections vers le même répertoire, elles sont interprétées dans l’ordre
                    - <Files> » et « </Files>
                    - <Location> » et « </location>
            - Gestion des accès simple
                - La directive « Require »
                    - Require all granted : L’accès est autorisé pour tous
                    - Require all denied : L’accès est refusé à tous
                    - Require ip @IP ( require ip 192.168.10.200 ) : autorise que pour l’hôte 192.168.10.200
                    - Require ip adresse_réseau ( require ip 192.168.10 ) : autorise que les hôtes du réseau 192.168.10.0 /24
                    - Require host suffixe_dns (require host tssr.lcl) : autorise que les hôtes dont le nom contient le suffixe dns tssr.lcl
                        - Recheche DNS Inverse (@IP => FQDN) puis une recherche DNS directe (FQDN => @IP)
                    - Require forward-dns nom_hôte (require forward-dns ad.tssr.lcl) autorise que l’hôte défini (adresse IP)
                        - Recheche DNS directe (FQDN => @IP)
                    - Require local : autorise que les adresses locales
                        - Le réseau 172.0.0.0 /8, l’adresse IP ::1, les adresses IP de l’hôte
            - Directive « Options »
                
                <aside>
                ⚠️ Peut être positionné sur:
                • Sur la configuration globale du serveur (apache2.conf)
                • Sur un hôte virtuel (VirtualHost)
                • Sur un répertoire (Directory)
                
                </aside>
                
                - All:
                    - Configuration par défaut. Toutes les options, sauf MultiViews
                - FollowSymLinks:
                    - Autorise le suivi des liens symboliques à positionner dans les répertoires
                - Indexes:
                    - Gère l’affichage du contenu si aucun fichier de démarrage présent
                - MultiViews:
                    - Gère la compatibilité d’affichage en fonction du navigateur
- répertoire pour les fichiers du site `/var/www/<nom.du.site>`
    - fichier de démarrage
        - créer un fichier index.html
    - contenu du site
        - ajouter dans le dossier tous les documents nécessaires au fonctionnement du site
- mise à dispo du site
    
    ```bash
    a2ensite <nom.du.site>
    ```
    
- reload du service apache
    
    ```bash
    systemctl reload apache2.service
    ```
    

# Gestion du service apache

- via systemctl
    
    ```bash
    Systemctl {start | stop | restart | reload | enable | disable | status} apache2
    ```
    
- via apache2ctl
    
    ```bash
    apache2ctl start #Démarre le daemon Apache
    apache2ctl stop #Arrête le daemon Apache
    apache2ctl restart #Redémarre ou démarre le daemon Apache
                #Vérification automatique des fichiers de configuration avant de lancer le redémarrage
    apache2ctl fullstatus #Affiche le rapport d'état complet
                #Le module mod_status doit être activé et vous devez disposer d'un navigateur en mode texte tel que lynx.
    apache2ctl status #Affiche un rapport d'état succinct.
    apache2ctl graceful #Redémarre ou démarre le démon en douceur.
                #Les connexions en cours ne sont pas fermées.
                #Cette option vérifie automatiquement les fichiers de configuration.
    apache2ctl graceful-stop #Arrête le démon quand disponible.
                #Les connexions en cours ne sont pas fermées.
    apache2ctl configtest #Effectue une vérification de la syntaxe
    apache2ctl –S #Affichage des sites publiés
    apache2ctl -l #Affichage des modules compilés avec Apache
                #Module statique : chargé au démarrage.
                #Module partagé : chargé à la demande.
    apache2ctl -? #Affichage des options disponibles
    ```
    

# Sécurisation de la connexion

- Gérer les ports d’écoute
    - modifier le fichier  `/etc/apache2/ports.conf`
    
    ```bash
    ajouter la directive listen <n° de port> pour ouvrir un port de façon générique
    si on veut ouvrir un port pour un module spécifique on place la directive entre les balises correspondantes
    Listen [adresse IP :]port [protocole]
    
    #exemple de fichier
    Listen 80
    Listen 8080
    
    <IfModule ssl_module>
                    Listen 443
    </IfModule>
    <IfModule mod_gnutls.c>
                    Listen 443
    </IfModule>
    ```
    
- Générer un certificat auto-signé (⇒ pas ouf en terme sécu)
    - Création de l’arborescence de stockage des certificats
        - créer les répertoires Certs-auto et reqs dans le dossier /etc/ssl/
        
        ```bash
        mkdir /etc/ssl/{cert-auto,reqs}
            #exemple
        #Tree -d /etc/ssl
        ├── certs #Les autorités de certifications connus
        │ └── java
        ├── certs-auto #Les certificats auto-signés
        ├── private #Les clés privées
        └── reqs #Les demandes de signatures de certificats
        ```
        
    - Création d’une clé privée
        - création de la clé dans le dossier “/etc/ssl/private”
            
            ```bash
            #openssl genrsa -des3 -out /etc/ssl/private/www.tssr.lcl.key 2048
            Generating RSA private key, 2048 bit long modulus
            .......................................................................................+++
            .............+++
            e is 65537 (0x10001)
            Enter pass phrase for /etc/ssl/private/private.key:
            Verifying - Enter pass phrase for /etc/ssl/private/private.key:
            
            - paramètres commandes
                - genrsa : génération d’une clé privée avec l’algorithme RSA
                - -des3 : oblige l’utilisation d’une phrase de passe pour protéger l’utilisation de la clé.
                - Cette phrase de passe sera demandée à chaque démarrage du serveur Apache. (facultatif)
                - -out chemin/fichier_clé_privée : chemin et nom du fichier contenant la clé privée.
                - 2048 : longueur de la clé en bits. Option a positionnée en dernier
            ```
            
    - Création d’un fichier de demande de « signature de certificat »
        
        <aside>
        ⚠️  ce sont les valeurs par défauts qui seront appelées lors des créations de certificat.
        
        </aside>
        
        - modifier le fichier /etc/ssl/openssl.cnf
            - En orange, les valeurs modifiées ou rajoutées
            
            ```bash
            req_distinguished_name ]
            countryName = Country Name (2 letter code)
            **countryName_default = FR**
            countryName_min = 2
            countryName_max = 2
            stateOrProvinceName = State or Province Name (full name)
            **stateOrProvinceName_default = Loire_Atlantique**
            localityName = Locality Name (eg, city)
            **localityName_default = Saint_Herblain**
            0.organizationName = Organization Name (eg, company)
            **0.organizationName_default = Eni-Ecole**
            organizationalUnitName = Organizational Unit Name (eg, section)
            **organizationalUnitName_default = Srv-Apache**
            commonName = Common Name (e.g. server FQDN or YOUR name)
            **commonName_default = www.tssr.lcl**
            commonName_max = 64
            emailAddress = Email Address
            **emailAddress_default = admin@tssr.lcl**
            emailAddress_max = 64
            ```
            
        - Création de la demande de signature de certificat
            - création de la demande dans le dossier “/etc/ssl/reqs”
            
            ```bash
            #openssl req -new -key /etc/ssl/private/www.tssr.lcl.key -out /etc/ssl/reqs/www.tssr.lcl.request.csr
            
            paramètres commande:
            • req : gestion des requêtes de certification
            • -new : nouvelle demande
            • -key chemin/fichier_clé_privée : clé privée à utiliser
            • -out chemin/fichier_demande_certificat : fichier contenant la demande de certificat
            ```
            
            - la commande demandera de confirmer:
                - la passphrase de la clé privée
                - les info du fichier /etc/ssl/openssl.cnf
    - Création d’un certificat auto-signé
        - création du certificat dans le dossier /etc/ssl/cert-auto/
        
        ```bash
        #openssl x509 -req -days 90 -in /etc/ssl/reqs/www.tssr.lcl.request.csr -signkey /etc/ssl/private/www.tssr.lcl.key -out /etc/ssl/certs-auto/www.tssr.lcl.cert
        
        paramètres commande:
        • x509 : gestion des certificats (auto-signés ou auprès d’une autorité de certification)
        • -req : demande de chiffrement de certificats
        • -days XXX : durée de validité du certificat en jours (par défaut : 365)
        • -in chemin/fichier_demande_certificat : fichier contenant la demande de signature de certificat
        • -signkey chemin/fichier_clé_privée : chemin et du fichier contenant la clé privée
        • - out chemin/fichier_certificat : chemin et nom du fichier contenant le certificat
        ```
        
    - Récupération d’un certificat provenant d’une AC
    - Modification du fichier configuration du site
        
        
    - Commandes supplémentaires
        - Suppression de la passphrase
            
            ```bash
            #openssl rsa -in /etc/ssl/private/www.tssr.lcl.key -out /etc/ssl/private/www.tssr.lcl-des3.key
            
            paramètres commande:
            • 
            ```
            
        - Création d’un clé privée et d’un certificat sans la demande de signature
            
            ```bash
            #openssl req -new -nodes -x509 -keyout /etc/ssl/private/www.tssr.lcl-des3.key -out /etc/ssl/certs-auto/www.tssr.lcl.cert -days 365 -newkey rsa:4096
            
            paramètres commandes:
            • req : demande de chiffrement de certificats
            • -new : nouvelle demande de certificat
            • -nodes : pas de cryptage de la clé privée
            • -x509 : gestion des certificats (auto-signés ou auprès d’une autorité de certification)
            • -keyout chemin/fichier_clé_privée : chemin et nom du fichier contenant la clé privée.
            • - out chemin/fichier_certificat : chemin et nom du fichier contenant le certificat
            • -days XXX : durée de validité du certificat en jours (par défaut : 365)
            • -newkey rsa :xxxx : longueur de la clé en bits
            ```
            
- Mise en place certificat sur le site
    - activation du module ssl (si pas déja fait)
        
        ```bash
        a2enmod ssl
        ```
        
    - modification du fichier de conf du site concerné (/etc/apache2/site-available/<nom.du.site.conf>
        
        ```bash
        <IfModule mod_ssl.c>
                    <VirtualHost * :443>
                                DocumentRoot /var/www/www.tssr.lcl
                                ServerName www.tssr.lcl
                                […]
                                SSLEngine on
                                SSLCertificateKeyFile /etc/ssl/private/www.tssr.lcl.key
                                SSLCertifcateFile /etc/ssl/certs-auto/www.tssr.lcl.cert
                                SSLProtocol all -SSLv3
                                […]
                    </VirtualHost>
        </IfModule>
        ```
        

# Mise en place d’un VPN (open VPN)

![Untitled](Untitled%2018.png)

# Ajout d’une AC sur routeur (Pfsense)

- Installation d’une AC sur Pfsense
    - Système / Gestionnaire de certificats / Acs
- Créer / Modifier l’AC
    - Nom descriptif
        - Nommer l’AC
    - Méthode
        - Créer une autorité de certification interne
- Autorité de certification
    - Key type
        - Type : RSA
        - Longueur : choisir le nombre de bits (minimum 2048)
    - Algorithme de hachage
        - Minimum SHA256
    - Durée de vie
        - Durée de validité des certificats
            - Par défaut 10 ans
    - Nom commun
        - Recopier le nom
    - Personnaliser l’AC
        - Pays / Province / Ville …
- Création du certificat serveur
    - Système / Gestionnaire de certificats / Certificats
        - Ajouter/Signer
- Ajouter/Signer un nouveau certificat
    - Méthode
        - Créer un certificat interne
    - Nom descriptif
        - Nommer le certificat serveur
- Certificat Interne
    - Autorité de certification
        - Choisissez l’AC
    - Key type
        - Type : RSA
        - Longueur : choisir le nombre de bits (minimum 2048)
    - Algorithme de hachage
        - Minimum SHA256
    - Durée de vie
        - Durée de validité de certificats
            - Maximum 398 jours
    - Nom commun
        - Recopier le nom
    - Personnaliser l’AC
        - Pays / Province / Ville …
- Attributs de certificat
    - Type de certificat
        - Certificat Serveur (Server certificate)
    - Noms alternatifs
        - Possibilité de rajouter des noms alternatifs
        - Ajout de FQDN

# Ajout d’une authentification LDAP (⇒p**rotocole qui permet de communiquer avec différents types d'annuaires)**

- Ajout de l’authentification LDAP
    - Système / Gestionnaire d’usagers / Serveurs d’authentification
        - Ajouter
- Paramètres du serveur
    - Nom descriptif
        - Nommer le serveur d’authentification
            - Nom du domaine AD
    - Type
        - LDAP
        
- Paramètres serveur LDAP
    - Nom d’hôte ou adresse IP
        - Indiquer le FQDN ou @IP du CD
    - Valeur du port
        - 389 ( port LDAP)
    - Transport
        - Standard TCP (par défaut)
    - Autorité de certification du pair
        - Choisir l’AC créée précédemment
    - Version du protocole
        - 3 (par défaut)
    - Délai de connexion au serveur
        - 25 (par défaut)
    - Champ de recherche
        - Level
            - Sous-arbre entier (toute l’arborescence LDAP)
            - Niveau unique (Une OU)
        - Base DN
            - Nom du domaine au format LDAP
            - dc=domaine,dc=tld
        - Conteneurs d’authentification
            - OU(s) ou conteneurs contenant les comptes utilisateurs utilisant le VPN
        - Requêtes étendues
            - Ne pas cocher « Activer les requêtes étendues »
    - Lier anonyme
        - Décocher pour indiquer le compte de liaison avec AD
    - Lier les informations d’identification
        - Renseigner le DN et son MDP du compte AD
    - Modèle initial
        - Microsoft AD
    - Attribut de nommage utilisateur
        - SamAccountName (en fonction du modèle)
    - Attribut de nommage de groupe
        - cn (en fonction du modèle)
    - Attribut de membre du groupe
        - Memberof (en fonction du modèle)
    - Les autres paramètres
        - Paramètres par défaut
- Test d’authentification
    - Serveur d’authentification
        - Choix du serveur
    - Nom d’utilisateur
    - Mot de passe
- Résolution DNS
    - Lier Pfsense avec le DNS
    - Système / Configuration générale
- Système
    - Domaine
        - Rajouter le suffixe DNS
- Paramètre du serveur DNS
    - Serveur DNS
        - Ajouter l’adresse IP du serveur DNS
    - Remplacer le serveur DNS
        - Décocher la case
    - DNS Resolution Behavior
        - Use remote DNS servers, Ignore local DNS
- Installation de paquets complémentaires
    - Système / Gestionnaires de paquets / Paquets disponibles
        - Ajouter le paquet « openvpn-client-export »
        - Permet d’export des bundle pré-configurés pour les clients
