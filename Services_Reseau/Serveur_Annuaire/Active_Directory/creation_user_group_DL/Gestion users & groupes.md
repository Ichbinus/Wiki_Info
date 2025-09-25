<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://www.iconarchive.com/download/i31978/tonev/windows-7/windows-7-user.ico" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Gestion des Users & Groupes sous Windows</h1>
</div>

# **Gestion des Users & Groupes via envirronement graphique <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**

- accès au groupes et utilisateur
    - via la console Gestion de l’ordinateur
- Gestion des passwd (en local)
    - via la console “stratégie de sécurité local”

# **Gestion des Users & Groupes via cmd <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**
## 📌 Accès aux Groupes
### Liste des groupes locaux
```powershell
net localgroup
```
### Liste des groupes d'un utilisateur spécifique
```powershell
whoami /groups
```
## 📌 Accès aux Utilisateurs
### Liste des utilisateurs locaux
```powershell
net user
```
### Informations détaillées sur un utilisateur
```powershell
net user username
```
## 🆕 Créer un Nouvel Utilisateur
```powershell
net user username password /add
```
## ➕ Ajouter un Utilisateur à un Groupe
```powershell
net localgroup groupname username /add
```
## ❌ Supprimer un Utilisateur d'un Groupe
```powershell
net localgroup groupname username /delete
```
## 🚫 Supprimer un Utilisateur
```powershell
net user username /delete
```
## 🔄 Modifier le Mot de Passe d'un Utilisateur
```powershell
net user username newpassword
```
## 📌 Vérifier l'Identité de l'Utilisateur Actuel
```powershell
whoami
```
## 📌 Changer d'Utilisateur
```powershell
runas /user:username cmd
```
---
# **Gestion des Users & Groupes avec PowerShell <img src="https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png" height="50px" />**
## En Local
### 📌 Accès aux Groupes
#### Liste des groupes locaux
```powershell
Get-LocalGroup
```
#### Liste des groupes d'un utilisateur spécifique
```powershell
Get-LocalUser -Name username | Get-LocalGroupMembership
```
### 📌 Accès aux Utilisateurs
#### Liste des utilisateurs locaux
```powershell
Get-LocalUser
```
#### Informations détaillées sur un utilisateur
```powershell
Get-LocalUser -Name username
```
### 🆕 Créer un Nouvel Utilisateur
```powershell
New-LocalUser -Name "username" -Password (ConvertTo-SecureString "password" -AsPlainText -Force) -FullName "User Full Name" -Description "User Description"
```
### ➕ Ajouter un Utilisateur à un Groupe
```powershell
Add-LocalGroupMember -Group "groupname" -Member "username"
```
### ❌ Supprimer un Utilisateur d'un Groupe
```powershell
Remove-LocalGroupMember -Group "groupname" -Member "username"
```
### 🚫 Supprimer un Utilisateur
```powershell
Remove-LocalUser -Name "username"
```
### 🔄 Modifier le Mot de Passe d'un Utilisateur
```powershell
Set-LocalUser -Name "username" -Password (ConvertTo-SecureString "newpassword" -AsPlainText -Force)
```
### 📌 Vérifier l'Identité de l'Utilisateur Actuel
```powershell
$env:USERNAME
```
### 📌 Changer d'Utilisateur
```powershell
Start-Process PowerShell -Credential "domain\username"
```
---
## Dans un Active directory
### 📌 Accès aux Groupes
#### Liste des groupes Active Directory
```powershell
Get-ADGroup -Filter *
```
#### Liste des groupes d'un utilisateur spécifique
```powershell
Get-ADUser -Identity username -Properties MemberOf | Select-Object -ExpandProperty MemberOf
```
### 📌 Accès aux Utilisateurs
#### Liste des utilisateurs Active Directory
```powershell
Get-ADUser -Filter *
```
#### Informations détaillées sur un utilisateur
```powershell
Get-ADUser -Identity username -Properties *
```
### 🆕 Créer un Nouvel Utilisateur
```powershell
New-ADUser -Name "User Full Name" -GivenName "FirstName" -Surname "LastName" -SamAccountName "username" -UserPrincipalName "username@domain.com" -Path "OU=Users,DC=domain,DC=com" -AccountPassword (ConvertTo-SecureString "password" -AsPlainText -Force) -Enabled $true
```
### ➕ Ajouter un Utilisateur à un Groupe
```powershell
Add-ADGroupMember -Identity "groupname" -Members "username"
```
### ❌ Supprimer un Utilisateur d'un Groupe
```powershell
Remove-ADGroupMember -Identity "groupname" -Members "username" -Confirm:$false
```
### 🚫 Supprimer un Utilisateur
```powershell
Remove-ADUser -Identity "username" -Confirm:$false
```
### 🔄 Modifier le Mot de Passe d'un Utilisateur
```powershell
Set-ADAccountPassword -Identity "username" -NewPassword (ConvertTo-SecureString "newpassword" -AsPlainText -Force) -Reset
```
### 📌 Vérifier l'Identité de l'Utilisateur Actuel
```powershell
whoami
```
### 📌 Changer d'Utilisateur
```powershell
runas /user:domain\username powershell
```
---