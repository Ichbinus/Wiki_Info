<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn-icons-png.flaticon.com/512/3962/3962060.png" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Gestion des disques sous Windows</h1>
</div>

# **Gestion des disques via DISKPART**
## **Accès à diskpart <img src=https://i0.wp.com/www.techspace.fr/wp-content/uploads/2014/12/diskpart.png height="50px" />**

- Diskpart est accessible via powershell ou cmd en tappant la commande suivante:
```cmd
diskpart
```
## **Lister les disques / partitions / volumes**
```cmd
list disk
```
```cmd
list partition
```
```cmd
list volume
```
## Sélectionner un disque / partition / volume
```cmd
select disk X 
```
```cmd
select partition X 
```
```cmd
select volume X 
```
> 💡X : numéro de la partition/disque/volume affiché dans la liste

---

## Création d'une partition
- après avoir sélectionné un disque
```cmd
create partition <type de partition> size=<taille partition en Mb>
```
- exemple :
```cmd
create partition primary size=15360
```
> 💡Donne une partition primaire de 15 Go

> 💡 **Attention** :  
> Si on est sur un disque MBR, on ne peut avoir que 4 partitions réelles maximum.  
> Pour ne pas gâcher la place restante, il faut créer en premier une partition étendue, puis une partition logique.

---

## Formatage
- après avoir sélectionné une partition: 
```cmd
format fs=<type de système de fichier> label=<nom du volume> quick
```
- exemple :
```cmd
format fs=ntfs label=DATA quick
```
> 💡 **Option possible** :  
> On peut ajouter une compression automatique avec `COMPRESS` à la fin.

---

## Attribuer une lettre à un volume
- après avoir sélectionné une partition
```cmd
assign letter=<lettre choisie>
```
- exemple :
```cmd
assign letter=D
```
---

## Convertir un disque
- après avoir sélectionné un disque
```cmd
convert <type de disque>
```
- exemple :
```cmd
convert Dynamique
```

---

## Étendre un volume
> 💡 **Ne peut se faire que sur des disques dynamiques**
- après avoir sélectionné le volume
```cmd
extend size=<taille à ajouter> <disk où prendre la place supplémentaire>
```
- exemple :
```cmd
extend size=15360 disk 2 
```
> 1. Si aucun disque n'est sélectionné, le volume sera étendu sur le disque où il est déjà placé.
> 2. Si aucune taille n'est spécifiée, toute la place disponible sur le disque sera ajoutée.

---

## Supprimer un volume
- après avoir sélectionné le volume
```cmd
delete volume
```

---

## Nettoyer un disque
- après avoir sélectionné un disque
```cmd
clean
```
---
# **Gestion des disques avec PowerShell <img src="https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png" height="50px" />**
---

## Obtenir des informations
```powershell
Get-Disk
```
```powershell
Get-Partition
```
```powershell
Get-Volume
```
---

## Création d'une partition
```powershell
New-Partition -<disque où faire la partition> -<taille partition> -<lettre de la partition>
```
- exemple: 
```powershell
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter T
```
---

## Formater une partition

```powershell
Format-Volume -DriveLetter <lettre partition souhaitée> -FileSystem <système de fichier> -NewFileSystemLabel <nom du volume>
```
- Exemple :
```powershell
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel DATA
```

---

## Partitionner & Formater un disk
> 💡 **On peut mixer les commandes avec PowerShell**
```powershell
Get-Disk | Where-Object PartitionStyle -Eq "RAW" | Initialize-Disk -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume
```
> Obtient tous les disques, filtre ceux qui sont en RAW (non partitionnés), les initialise, les partitionne et les formate.

---

## Changer l’identification d’un volume
```powershell
Set-Volume -DriveLetter <lettre souhaitée> -NewFileSystemLabel <étiquette du volume>
```
- Exemple :
```powershell
Set-Volume -DriveLetter D -NewFileSystemLabel DATA
```
---

## Supprimer une partition
```powershell
Remove-Partition -<n° du disque> -<n° de la partition>
```
-  Exemple :
```powershell
Remove-Partition -DiskNumber 5 -PartitionNumber 2
```
---

## Nettoyer un disque
```powershell
Clear-Disk -<n° du disque>
```
- Exemple :
```powershell
Clear-Disk -Number 2
```

