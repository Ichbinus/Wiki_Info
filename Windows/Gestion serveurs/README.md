<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://cdn.worldvectorlogo.com/logos/windows-server.svg" height="50px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h1 align="center">Services sur Windows Servers</h1>
</div>


---

# Installation de rôles

## Interface graphique

- depuis le gestionnaire de serveur, cliquez sur ajouter rôles et fonctionnalités

    ![ws_service_1](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/images_services_WS/ws_service_1.png)

- sélectionner le rôle de serveur a ajouter (DHCP, DNS, active directory,…)

    ![ws_service_2](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/images_services_WS/ws_service_2.png)

- Valider les fonctionnalités nécessaires

    ![ws_service_3](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/images_services_WS/ws_service_3.png)

- personnaliser les fonctionnalités si besoin

    ![ws_service_4](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/raw/branch/main/Windows/Gestion%20serveurs/images_services_WS/ws_service_4.png)

- confirmer les modules allant être installés et lancer l’installation

## Via Powershell

- installation du Rôle

    ```powershell
    Install-WindowsFeature "Role"
    ```

# Tutos d'installation des serfices Windows

- **Service de déploiement MDT/WDS** ➡️ [`Service de déploiement MDT/WDS`](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/src/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Deploiements%20MDT.md#)
- **Service de Bureau à distance** ➡️ [`Remote Desktop`](https://gitea.maxflix.xyz/Ichbine/Wiki_Info/src/branch/main/Windows/Gestion%20serveurs/Services%20Servers%20Windows/Remote%20Desktop.md#)
