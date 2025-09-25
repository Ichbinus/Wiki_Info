<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://memos.nadus.fr/wp-content/uploads/2018/05/le-partage-de-fichiers-icone-psd_30-2568.jpg" height="100px" />
    </a>
  </p>
</div>
<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Récupération des information machine sous Windows</h1>
</div>

# **Gestion des information machine via cmd <img src=https://cdn.iconscout.com/icon/premium/png-256-thumb/command-prompt-3477885-2910207.png height="50px" />**
# Info machine
```cmd
systeminfo | findstr /B /C:"Nom de l'hôte" /C:"OS Name" /C:"OS Version" /C:"Architecture"
```
# Info processeur
```cmd
wmic cpu get Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
```
# Info mémoire (équivalent lsmem)
```cmd
wmic memorychip get Capacity, Manufacturer, PartNumber, Speed
```
# Info processus en cours (équivalent lsof et ps)
```cmd
wmic process get ProcessId, Name, ExecutablePath
```
```cmd
tasklist
```
# Surveillance machine
```cmd
tasklist /v
```
---
---
# **Gestion des informations machine via PowerShell <img src="https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png" height="50px" />**
# Info machine
```powershell
Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture
```
# Info processeur
```powershell
Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
```
# Info mémoire
```powershell
Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object Capacity, Manufacturer, PartNumber, Speed
```
# Info processus en cours
```powershell
Get-Process | Select-Object Id, ProcessName, Path
```
# Surveillance machine
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Id, ProcessName, CPU
```