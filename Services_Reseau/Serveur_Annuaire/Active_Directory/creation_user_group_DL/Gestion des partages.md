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
## Mise en place du partage
### créer un partage
```powershell
New-SmbShare -Name "nom du partage" -Path "chemin vers le dossier de partage" -FullAccess "groupe d'utilisateur" -ReadAccess "groupe d'utilisateur"
```
- exemple
```powershell
New-SmbShare -Name Partage -Path "C:\Partage\" -FullAccess "Administrateurs" -ReadAccess "Utilisateurs"
```
--- 
### lister les partages
```powershell
Get-SmbShare 
```
---
## Gérer les droits NTFS sur le partage
### ajouter des droits d'accès sur le partage
```powershell
Grant-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits" -AccessRight "type de droit" -Force
```
> 💡 Le paramètre -Force permet de zapper la confirmation.
- exemple: 
```powershell
Grant-SmbShareAccess -Name "Partage" -AccountName "Ichbine" -AccessRight Full -Force
``` 
---
### supprimer des droits d'accès sur le partage
```powershell
Revoke-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits" -Force
```
> 💡 Le paramètre -Force permet de zapper la confirmation.
- exemple: 
```powershell
Revoke-SmbShareAccess -Name "Partage" -AccountName "florian@it-connect.local" -Force
```
---
### Refuser des droits d'accès sur le partage
```powershell
Bloke-SmbShareAccess -Name "chemin vers le dossier de partage" -AccountName "compte dont on veut vérifier les droits" -Force
```
- exemple: 
```powershell
Bloke-SmbShareAccess -Name "Partage" -AccountName "florian@it-connect.local" -Force
```
> 💡 Le paramètre -Force permet de zapper la confirmation.

> 💡 on peut débloquer en changeant Bloke par Unbloke    