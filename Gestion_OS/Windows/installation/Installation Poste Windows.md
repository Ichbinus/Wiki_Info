# **Tutoriel d'installation d'un poste Windows**

## **1. Préparation du support d'installation**

### **Créer une clé USB bootable avec l'outil Microsoft**
1. Télécharger l'outil de création de support sur le site officiel de Microsoft.
2. Exécuter l'outil et choisir **"Créer un support d’installation (clé USB, DVD ou fichier ISO) pour un autre PC"**.
3. Sélectionner la langue, l’édition et l’architecture souhaitées.
4. Insérer une clé USB d’au moins **8 Go**, puis choisir cette clé comme destination.
5. Laisser l’outil télécharger et préparer la clé.

### **Créer une clé USB bootable avec Rufus**
1. Télécharger et exécuter **Rufus**.
2. Sélectionner l’image ISO de Windows.
3. Choisir la clé USB comme destination.
4. Configurer les options :
   - **Type de partition** : GPT (UEFI) ou MBR (BIOS).
   - **Système de fichiers** : NTFS ou FAT32.
5. Démarrer la création de la clé.

---

## **2. Installation de Windows**

### **Démarrer sur la clé USB**
1. Insérer la clé USB dans le PC.
2. Accéder au **BIOS/UEFI** en appuyant sur **F2, F12, DEL ou ESC** selon le fabricant.
3. Modifier l'ordre de démarrage pour placer la clé USB en premier.
4. Sauvegarder et redémarrer.

### **Lancer l’installation**
1. Choisir la langue, le format horaire et la méthode de saisie.
2. Cliquer sur **Installer maintenant**.
3. Entrer la clé de produit ou cliquer sur **Je n’ai pas de clé de produit**.
4. Sélectionner l’édition de Windows (si demandé).
5. Accepter les termes du contrat de licence.

### **Choisir le type d’installation**
- **Mise à niveau** : Conserve les fichiers et applications.
- **Personnalisé** : Installation propre, formatage possible.

### **Partitionnement du disque**
1. Sélectionner le disque où installer Windows.
2. Supprimer les partitions existantes (si nécessaire).
3. Créer une nouvelle partition principale.
4. Sélectionner la partition et cliquer sur **Suivant**.

### **Installation et premier démarrage**
1. L'installation démarre et l'ordinateur redémarrera plusieurs fois.
2. Configurer les options de **région et clavier**.
3. Choisir **Compte Microsoft ou local**.
4. Configurer les options de confidentialité et la connexion réseau.
5. Patienter pendant la finalisation de l'installation.

---

## **3. Configuration post-installation**

### **Mises à jour et pilotes**
1. Accéder à **Paramètres > Windows Update** et installer les mises à jour.
2. Télécharger les pilotes manquants via **Gestionnaire de périphériques** ou sur le site du fabricant.

### **Optimisation et sécurité**
- Activer **Windows Defender** et configurer un pare-feu.
- Installer les logiciels essentiels (navigateur, suite bureautique, etc.).
- Désactiver les applications inutiles au démarrage.
- Vérifier l’activation de Windows.

---

## **4. Finalisation et sauvegarde**

1. Créer un point de restauration.
2. Configurer une sauvegarde automatique via **Historique des fichiers**.
3. Vérifier que tout fonctionne correctement (réseau, audio, affichage).

🎉 **Votre poste Windows est maintenant installé et prêt à l’emploi !**
