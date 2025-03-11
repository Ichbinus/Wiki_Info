# Définir les chemins de l'arborescence
$directories = @(
    "S:\DATA",
    "S:\DATA\COMMUN",
    "S:\PROFILS",
    "S:\DATA\PROCESS",
    "S:\DATA\SERVICES",
    "S:\PRESENTATIONS"
)

# Créer les répertoires
foreach ($dir in $directories) {
    if (-Not (Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory
        Write-Host "Created directory: $dir"
    } else {
        Write-Host "Directory already exists: $dir"
    }
}