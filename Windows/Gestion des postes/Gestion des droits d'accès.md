<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://www.cerfi.ch/Htdocs/Images/Pictures/puid_a6f6619a-71f9-48f2-a424-541d8c7ff960_6620.jpg" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Gestion des droits d'accès sous Windows</h1>
</div>

# **Gestion des disques via cmd <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**
## afficher des droits d’un dossier / fichier
```cmd
icacls <chemin du fishier/dossier>
```
- exemple:
```cmd
icacls F:\Téléchargement
```
---
## ajouter des droits à un dossier / fichier
```cmd
icacls <chemin du fishier/dossier> /grant <nom du compte>: (droits à ajouter)
```
- exemple:
```cmd
	icacls F:\Téléchargement /grant Administrator:(D,RX)
```
>liste des droits:
>			N - no access
>           F - full access
>           M - modify access
>           RX - read and execute access
>           R - read-only access
>           W - write-only access
>           D - delete access

---
## ajouter des interdictions à un dossier / fichier
```cmd
icacls <chemin du fishier/dossier> /deny <nom du compte>: (interdiction à ajouter)
```
- exemple:
```cmd
	icacls F:\Téléchargement /deny Frederic:(D,RX)
```
>liste des droits
>        	N - no access
>           F - full access
>           M - modify access
>           RX - read and execute access
>           R - read-only access
>           W - write-only access
>           D - delete access
---

# **Gestion des Powershell via cmd <img src=https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png height="50px" />**

## afficher des droits d’un dossier / fichier 
```powershell
Get-Acl <chemin du fichier/dossier>
```
- exemple
```powershell
Get-Acl m:\2022
```
    
## copier des droits d’un dossier / fichier sur un autre
```powershell
Get-acl -Path <chemin du fichier/dossier source> |Set-Acl -Path <chemin du fichier/dossier cible>
```
- exemple: 
```powershell
    Get-Acl -Path "C:\Dog.txt" | Set-Acl -Path "C:\Cat.txt"
```
    
## Gérer les droit (ACL)
- prérequis: installation du module powershell ntfssecurity
```powershell
Install-Module NTFSSecurity
```
## Ajouter des droits
```powershell
Add-NTFSAccess -Path "dossier_cible" -AccessRight "type_de_droits" -Account "groupe_de_domaine_local_souhaité"
```
        
## lister les droits
```powershell
Get-NTFSAccess "dossier_cible" |format-Table -Wrap
```
        
## Gérer les partages
### Ajouter des droits
```powershell
New-SMBShare -Name "Nom_du_Partage" -Path "dossier_cible" -"type_de_droits" "list_users"
```
        
### lister les droits
```powershell
Get-SMBShare -Name "Nom_du_Partage" 
```