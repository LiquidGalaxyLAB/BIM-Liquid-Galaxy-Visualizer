# BIM Liquid Galaxy Visualizer

[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/blob/main/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
![GitHub repo size](https://img.shields.io/github/repo-size/LiquidGalaxyLAB/reforestation-assistant-simulator)
![Coverage](https://raw.githubusercontent.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/main/bim_visualizer_flutter/coverage_badge.svg?sanitize=true)

BIM Liquid Galaxy Visualizer is a tool that allows the visualization of demo or uploaded BIM models using the liquid galaxy rig system or using augmented reality, both with an android device

## Requirements

[Flutter Stable](https://docs.flutter.dev/get-started/install)  
[Android Studio](https://developer.android.com/studio)

## Quick step guide

### Cloning the Repository

Change the current work directory to the root directory of your lg rig eg. `/home/lg` by typing `cd /home/lg` into a command line terminal and then clone this repository into it by running

```
git clone https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer projects/BIM-Liquid-Galaxy-Visualizer && cd projects/BIM-Liquid-Galaxy-Visualizer
```

### Server install

Change the current working directory to `bim_visualizer_node` by typing `cd bim_visualizer_node`

Install the server with the `install.sh` script

```
bash install.sh
```

The script will install some OS needed dependencies like `chromium-browser`, `sshpass` and `npm` and then it will install the project dependencies.

:warning: ***Pay attention for when the system password is asked***

If it is the first time running the install script into the machine, the system should be reboot

After the installation completion the server can be runned by typing

```
node server.js
```

:warning: **Remember to always run the server before the app**

### Running the app locally

Open the `bim_visualizer_flutter` directory with android studio. Plug your device or launch the simulator by clicking in `Device Manager` action located at Tools > Device Manager. Finally, run the app by clicking in `Run` action located at Run > Run 'main.dart'

### Running the app with APK

Download, with your device, the stable version (most recent) of the [APK](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/releases/download/1.0.0/BIMLGVIS-1.0.0.apk) (can be found in the releases section), 
Locate the downloaded file with an file manager (normally the downloaded file should be found into the downloads directory), open it and then follow the apk wizard installation

## Known Issues

- Sometimes the close action of the app doesnt close in all displays, in these cases, the displays can be closed manually by runing the `close.sh` script located at the `libs` directory of the server (bim_visualizer_node). When running the close script it should be informed the system password. ie `bash close.sh [password]`

## License

This software is distributed under the MIT license, more information can be found in the [LICENSE](LICENSE) file