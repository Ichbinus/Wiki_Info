# **Sous cmd avec outils de gestion DISKPART**

```cmd
diskpart
# permet d'accéder à l'outil de gestion de disque sous cmd
```

## Lister les disques / partitions / volumes

```cmd
list disk |ou| partition |ou| volume
```

## Sélectionner un disque / partition / volume

```cmd
select disk X |ou| partition X |ou| volume X
# X : numéro de la partition/disque/volume affiché dans la liste
```

## Création d'une partition

```cmd
# après avoir sélectionné un disque
create partition <type de partition> size=<taille partition en Mb>
# exemple :
create partition primary size=15360 # donne une partition primaire de 15 Go
```

> 💡 **Attention** :  
> Si on est sur un disque MBR, on ne peut avoir que 4 partitions réelles maximum.  
> Pour ne pas gâcher la place restante, il faut créer en premier une partition étendue, puis une partition logique.

## Formatage

```cmd
# après avoir sélectionné une partition
format fs=<type de système de fichier> label=<nom du volume> quick
# exemple :
format fs=ntfs label=DATA quick
```

> 💡 **Option possible** :  
> On peut ajouter une compression automatique avec `COMPRESS` à la fin.

## Attribuer une lettre à un volume

```cmd
# après avoir sélectionné une partition
assign letter=<lettre choisie>
# exemple :
assign letter=D
```

## Convertir un disque

```cmd
# après avoir sélectionné un disque
convert <type de disque>
# exemple :
convert Dynamique
```

## Étendre un volume

> 💡 **Ne peut se faire que sur des disques dynamiques**

```cmd
# après avoir sélectionné le volume
extend size=<taille à ajouter> <disk où prendre la place supplémentaire>
# exemple :
extend size=15360 disk 2 
# 1. Si aucun disque n'est sélectionné, le volume sera étendu sur le disque où il est déjà placé.
# 2. Si aucune taille n'est spécifiée, toute la place disponible sur le disque sera ajoutée.
```

## Supprimer un volume

```cmd
# après avoir sélectionné le volume
delete volume
```

## Nettoyer un disque

```cmd
# après avoir sélectionné un disque
clean
```

# **Gestion des disques avec PowerShell**

## Obtenir des informations

```powershell
Get-Disk / Get-Partition / Get-Volume
```

## Partitionner

```powershell
New-Partition -<disque où faire la partition> -<taille partition> -<lettre de la partition>
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter T
```

> 💡 **On peut mixer les commandes avec PowerShell**

```powershell
Get-Disk | Where-Object PartitionStyle -Eq "RAW" | Initialize-Disk -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume
# Obtient tous les disques, filtre ceux en RAW (non partitionnés), les initialise, les partitionne, et les formate
```

## Formater

```powershell
Format-Volume -DriveLetter <lettre partition souhaitée> -FileSystem <système de fichier> -NewFileSystemLabel <nom du volume>
# Exemple :
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel DATA
```

## Changer l’identification d’un volume

```powershell
Set-Volume -DriveLetter <lettre souhaitée> -NewFileSystemLabel <étiquette du volume>
# Exemple :
Set-Volume -DriveLetter D -NewFileSystemLabel DATA
```

## Supprimer une partition

```powershell
Remove-Partition -<n° du disque> -<n° de la partition>
# Exemple :
Remove-Partition -DiskNumber 5 -PartitionNumber 2
```

## Nettoyer un disque

```powershell
Clear-Disk -<n° du disque>
# Exemple :
Clear-Disk -Number 2

