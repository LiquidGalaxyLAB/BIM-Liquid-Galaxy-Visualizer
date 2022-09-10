<p align="center">
    <img src="https://user-images.githubusercontent.com/43768274/186247822-6ffada21-7064-4c19-a650-ae1d99bc70d3.png" width="350" height="200"/>
</p>

<!-- # BIM Liquid Galaxy Visualizer -->

[Project Documentation](https://docs.google.com/document/d/1wCPtYu7jgcStSviWJShtIEqMmz0kIg7tpTtxei1VBpc/edit?usp=sharing) |
[App on Play Store](https://play.google.com/store/apps/details?id=com.galaxy.bim_visualizer) |
[Releases](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/releases/) | [Wiki](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/wiki)

[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/blob/main/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
[![GitHub release](https://img.shields.io/github/release/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer.svg)](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/releases/)
![Coverage](https://raw.githubusercontent.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/main/bim_visualizer_flutter/coverage_badge.svg?sanitize=true)

BIM Liquid Galaxy Visualizer is a tool that allows the visualization of demo or uploaded BIM 3D models and metadatas on the liquid galaxy RIG system using an android device

## Table of Contents

- [1. Quick Step Guide](#quick-step-guide-rocket)
    * [1.1 Clonning the Repository](#cloning-the-repository)
    * [1.2 Server Install](#server-install)
    * [1.3 Local Tunnel](#local-tunnel)
    * [1.4 Running the App Locally](#running-the-app-locally)
        * [1.3.1 Flutter Installation on Linux](#flutter-installation-on-linux)
        * [1.3.2 Android SDK](#android-sdk)
        * [1.3.3 Running the App](#running-the-app)
    * [1.4 Running the App With APK](#running-the-app-with-apk)
- [2. Running Tests](#running-tests-traffic_light)
- [3. License](#license-clipboard)
- [4. Acknowledgements](#acknowledgements-purple_heart)

## Quick Step Guide :rocket:

[(Back to Top)](#bim-liquid-galaxy-visualizer)

For tests purpose you can follow with the [Running the app with the APK](#running-the-app-with-apk) guideline, and then, install the server using the task inside the app settings

Case you want install and run the server manually, follow with the next steps

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

If it is the first time running the install script into the machine, the system should be reboot

After the installation completion the server can be runned by typing

```
npm start
```

:warning: **Remember to always run the server before the app**

### Local tunnel

As we cant access the virtual interface of the galaxy (eth0:0 | lg1 | 10.42.42.1) from outside the system eg wifi network we need to expose this interface so we can access the controller from our tablet. A way founded to expose the url was by using an tunnel system.
We have two ports: 3210 that is the server and 3220 that is the socket.
With the following commands we can expose both ports to the `bimlgvisualizer-server` and `bimlgvisualizer-socket` subdomains.

```
lt --subdomain bimlgvisualizer-server --port 3210
lt --subdomain bimlgvisualizer-socket --port 3220
```

:warning: ***Ensure that the generated links has the correct subdomain in other case the system will not work***

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

Download, with your device, the stable version (most recent) of the [APK](https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer/releases/download/1.3.0/BIMLGVIS-1.3.0.apk) (can be found in the releases section), 
Locate the downloaded file with an file manager (normally the downloaded file should be found into the downloads directory), open it and then follow the apk wizard installation

## Running tests :traffic_light:

[(Back to Top)](#bim-liquid-galaxy-visualizer)

To run the app tests first generate the mock files with the following command

```
flutter pub run build_runner build
```

Then run `flutter test --coverage` command to generate a test coverage report page

To view the generated page run `open coverage/index.html`

## License :clipboard:

[(Back to Top)](#bim-liquid-galaxy-visualizer)

This software is distributed under the MIT license, more information can be found in the [LICENSE](LICENSE) file

## Acknowledgements :purple_heart:

[(Back to Top)](#bim-liquid-galaxy-visualizer)

The experience of being a GSoC student is beyond a code and i'm very grateful for have had this opportunity. All my thanks is to the Liquid Galaxy Organization Admin Andreu Ibánez for give me this oportunity also my mentors Karine Pistili and Marc Capdevila for being helpful not only on the bonding\coding period but before the project theme definition, the Lleida Liquid Galaxy Support Pau Francino for helping with the app test also Alejandro Illán Marcos for release the app into the Play store and finally my friends and family for the support.
