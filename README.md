# BIM Liquid Galaxy Visualizer

[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/blob/main/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
![GitHub repo size](https://img.shields.io/github/repo-size/LiquidGalaxyLAB/reforestation-assistant-simulator)
![Coverage](https://raw.githubusercontent.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/main/bim_visualizer_flutter/coverage_badge.svg?sanitize=true)

BIM Liquid Galaxy Visualizer is a tool that allows the visualization of demo or uploaded BIM models using the liquid galaxy rig system or using augmented reality, both with an android device

## Table of Contents

- [1. Quick Step Guide](#quick-step-guide)
    * [1.1 Clonning the Repository](#cloning-the-repository)
    * [1.2 Server Install](#server-install)
    * [1.3 Running the App Locally](#running-the-app-locally)
        * [1.3.1 Flutter Installation on Linux](#flutter-installation-on-linux)
        * [1.3.2 Android SDK](#android-sdk)
        * [1.3.3 Running the App](#running-the-app)
    * [1.4 Running the App With APK](#running-the-app-with-apk)
- [2. Known Issues](#known-issues)
- [3. License](#license)

## Quick Step Guide

### Cloning the Repository

[(Back to Top)](#bim-liquid-galaxy-visualizer)

Change the current work directory to the root directory of your lg rig eg. `/home/lg` by typing `cd /home/lg` into a command line terminal and then clone this repository into it by running

```
git clone https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer projects/BIM-Liquid-Galaxy-Visualizer && cd projects/BIM-Liquid-Galaxy-Visualizer
```

### Server Install

[(Back to Top)](#bim-liquid-galaxy-visualizer)

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
npm start
```

:warning: **Remember to always run the server before the app**

### Running the App Locally

[(Back to Top)](#bim-liquid-galaxy-visualizer)

The app can be executed both with the source code or with the apk. For tests purpose, the [Running the App With APK](#running-the-app-with-apk) guideline should be helpful.  
If you want to run with the source code follow the next steps

#### Flutter Installation on Linux

[(Back to Top)](#bim-liquid-galaxy-visualizer)

As cited into the [Flutter Documentation](https://docs.flutter.dev/get-started/install/linux) `the easiest way to install Flutter on Linux is by using snapd`

If you're running Ubuntu 16.04 LTS (Xenial Xerus) or later you should have the snap installed and ready to go, otherwise, you can install the snap from the Ubuntu Software Centre by searching `snapd`

To install the Flutter SDK with snap just run the following command line

```
 sudo snap install flutter --classic
```

Once you have Flutter SDK installed you can check the path with the `flutter sdk-path` command

#### Android SDK

[(Back to Top)](#bim-liquid-galaxy-visualizer)

To run an app into an android device its necessary to have the Android SDK intalled. The installation of the Android SDK itself can be trickful, so, to make it easier we can install the [Android Studio IDE](https://developer.android.com/studio). By intalling Android Studio it should be installed the Android SDK too

#### Running the App

[(Back to Top)](#bim-liquid-galaxy-visualizer)

First plug your device into your machine, then, open a command line terminal and change the current work directory to the `bim_visualizer_flutter` directory. Finally run the `flutter run` command to start the app.  
Once the build finishes, the app should run into the connected device

### Running the App With APK

[(Back to Top)](#bim-liquid-galaxy-visualizer)

Download, with your device, the stable version (most recent) of the [APK](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/releases/download/1.0.0/BIMLGVIS-1.0.0.apk) (can be found in the releases section), 
Locate the downloaded file with an file manager (normally the downloaded file should be found into the downloads directory), open it and then follow the apk wizard installation

## Known Issues

[(Back to Top)](#bim-liquid-galaxy-visualizer)

- Sometimes the close action of the app doesnt close in all displays, in these cases, the displays can be closed manually by runing the `close.sh` script located at the `libs` directory of the server (bim_visualizer_node). When running the close script it should be informed the system password. ie `bash close.sh [password]`

## License

[(Back to Top)](#bim-liquid-galaxy-visualizer)

This software is distributed under the MIT license, more information can be found in the [LICENSE](LICENSE) file
