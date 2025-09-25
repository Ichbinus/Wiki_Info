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