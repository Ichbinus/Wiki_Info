<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://memos.nadus.fr/wp-content/uploads/2018/05/le-partage-de-fichiers-icone-psd_30-2568.jpg" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Gestion des partages sous Windows</h1>
</div>

# Gestion des accès au partage

1. lors de la mise en place du partage il faut ne laisser que les “utilisateur authentifiés” (et les utilisateurs systèmes (admin + système)
2. Accorder le contrôle totale aux utilisateurs identifiés
3. Les autorisations d’ccès seront gérées par les droits NTFS

# **Gestion des partages via cmd <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**
## Définir un partage
```cmd
net share <Nom du partage>=<chemin/du/dossier/partagé>
```
- exemple:
```cmd
net share MonPartage=c:\share
```
> 💡 On peut ajouter un commentaire au partage avec l'option /Remark
---
## ajouter/modifier les droits d’un partage
- L’option /Grant permet d’indiquer les autorisations sur le partage
```cmd
net share <Nom du partage>=<chemin/du/dossier/partagé> /GRANT:<User>,<type de droit>
```
- exemple:
```cmd
net share MonPartage=c:\share /GRANT:Ichbine,Full
```
> 💡 les droits sont les suivants: 
>READ : pour donner accès qu’en lecture sur le partage réseau
>CHANGE : pour donner les autorisations en modifications
>FULL : donne le contrôle total
---

# **Gestion des partage avec PowerShell <img src="https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png" height="50px" />**

- Déclarer un partage
    
    ```powershell
    New-SmbShare -Name "nom du partage" -Path "chemin vers le dossier de partage" -FullAccess "groupe d'utilisateur" -ReadAccess "groupe d'utilisateur"
    #exemple
    	New-SmbShare -Name Partage -Path "C:\Partage\" -FullAccess "Administrateurs" -ReadAccess "Utilisateurs"
    ```
    
- consulter les droits d’un partage
    
    ```powershell
    Get-SmbShareAccess -Name "nom du partage"
    #exemple
    	Get-SmbShareAccess -Name "Partage"
    ```
    
- Gérer les droits NTFS sur le partage
    
    <aside>
    💡 on peut avoir besoin d’installer un module complémentaire
    
    `Install-Module NTFSSecurity`
    
    </aside>
    
    - consulter les droits NTFS du partage
    
    ```powershell
    Get-NTFSAccess -Path "chemin vers le dossier de partage"
    #exemple
    	Get-NTFSAccess -Path "C:\Partage"
    ```
    
    <aside>
    💡 types de droits:
    
    - **FullControl**
    - **ReadAndExecute**
    </aside>
    
    - Ajouter des droits NTFS
    
    ```powershell
    Add-NTFSAccess -Path "chemin vers le dossier de partage" -Account "compte dont on veut vérifier les droits"  -AccessRights "type de droits"
    #exemple
    	Add-NTFSAccess -Path "C:\Partage\" -Account "florian@it-connect.local" -AccessRights Modify
    ```
    
    - Enlever des droits NTFS
    
    ```powershell
    Remove-NTFSAccess -Path "chemin vers le dossier de partage" -Account "compte dont on veut vérifier les droits" -AccessRights "type de droits"
    #exemple
    	Remove-NTFSAccess -Path "C:\Partage\" -Account "florian@it-connect.local" -AccessRights Modify
    ```
    
- Configurer le partage
    
    <aside>
    💡 types de droits avec le paramètre -Accessright
    
    - **Full**
    - **Read**
    - **Change**
    - **Custom**
    </aside>
    
    - consulter les droits de Partage
    
    ```powershell
    Get-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits"
    #exemple
    	Get-SmbShareAccess -Name "C:\Partage\" -AccountName "florian@it-connect.local"
    ```
    
    - ajouter des droits sur le partage
    
    ```powershell
    Grant-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits" -AccessRight "type de droit" -Force #permet de ne pas demander de confirmation
    #exemple
    	Grant-SmbShareAccess -Name "Partage" -AccountName "florian@it-connect.local" -AccessRight Read -Force
    ```
    
    - supprimer des droits sur le partage
    
    ```powershell
    Revoke-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits" -Force #permet de ne pas demander de confirmation
    #exemple
    	Revoke-SmbShareAccess -Name "Partage" -AccountName "florian@it-connect.local" -Force
    ```
    
    - Bloquer l’accès à un partage
    
    ```powershell
    Bloke-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits" -Force #permet de ne pas demander de confirmation
    #exemple
    	Bloke-SmbShareAccess -Name "Partage" -AccountName "florian@it-connect.local" -Force
    
    #N.B: on peut débloquer en changeant Bloke par Unbloke
    ```
    
- Script complet
    
    ```powershell
    param (
        [string]$FolderPath,
        [string]$FolderName,
        [string]$share
    )
    
    # Importer le module Active Directory
    Import-Module ActiveDirectory
    #Install-Module NTFSSecurity
    Import-Module NTFSSecurity
    
    # Définir les noms des groupes
    $domain = (Get-ADDomain).DNSRoot
    $groupPrefix = "DL-$FolderName"
    
    $groups = @{
        "Refus"         = "$groupPrefix-R"
        "ControleTotal" = "$groupPrefix-CT"
        "Ecriture"      = "$groupPrefix-E"
        "Lecture"       = "$groupPrefix-L"
    }
    
    # Créer les groupes dans Active Directory
    foreach ($key in $groups.Keys) {
        $groupName = $groups[$key]
        $PathDL = "OU=03-Ressources,OU=22-Services,OU=MT,DC=mt,DC=msprsx,DC=eni"
        if (-Not (Get-ADGroup -Filter { Name -eq $groupName })) {
            New-ADGroup -Name $groupName -SamAccountName $groupName -GroupScope DomainLocal -Path $PathDL
            Write-Host "Created AD Group: $groupName"
        } else {
            Write-Host "AD Group already exists: $groupName"
        }
    }
    
    # Fonction pour partager un dossier
    function Share-Folder {
        if (-Not (Get-SmbShare -Name $share -ErrorAction SilentlyContinue)) {
            New-SmbShare -Name $share -Path $folderPath  
            $droits_partage = Get-SmbShareAccess -Name $share
            foreach ($compte in $droits_partage){
            $compte_list = $compte.AccountName
                if($compte_list -notlike "Utilisateurs du domaine"){
                    Revoke-SmbShareAccess -AccountName $compte_list -Name $share -Force
                    Grant-SmbShareAccess -Name $share -AccountName "$domain\Utilisateurs du domaine" -AccessRight Full -Force
                    }
            }
            Write-Host "Created share: $share"
        } else {
            Write-Host "Share already exists: $share"
        }
    }
    
    # Fonction gestion des droits NTFS dossier partagé
    function Permission-Dossier {
            # Ajout des groupes DL au permission du dossier
            foreach ($key in $groups.Keys) {
            $groupName = $groups[$key]
                if ($groupName -like "*-CT"){
                    Add-NTFSAccess -Path $folderPath -Account "$groupName@$domain" -AccessRights FullControl 
                } elseif ($groupName -like "*-E"){
                    Add-NTFSAccess -Path $folderPath -Account "$groupName@$domain" -AccessRights ReadAndExecute
                } elseif ($groupName -like "*-L"){
                    Add-NTFSAccess -Path $folderPath -Account "$groupName@$domain" -AccessRights Read
                }
            }
            # Obtenir la liste des comptes autorisés et leurs permissions sur le chemin spécifié
            $compt_autor = Get-NTFSAccess -Path $folderPath
    
            # Itérer à travers chaque compte autorisé
            foreach ($compt in $compt_autor) {
                $Account = $compt.Account
                $AccessRights = $compt.AccessRights
    
                # Afficher le nom du compte
                Write-Output "Traitement du compte : $Account"
    
                # Condition pour vérifier si le compte ne contient pas "$share"
                if ($Account -notlike "*$share*") {
                    # Retirer les permissions pour le compte
                    Write-Output "Retrait des permissions pour le compte : $Account"
                    Remove-NTFSAccess -Path $folderPath -Account $Account -AccessRights $AccessRights
                } else {
                    Write-Output "Le compte $Account contient 'DATA' et ne sera pas modifié."
                }
            }
        }
    
    Share-Folder 
    Permission-Dossier
    
    Write-Host "Script execution completed."
    
    ```