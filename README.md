# web_qr_system

:warning: **IMPORTANT NOTE**: This application is still **in development** and should **not** be used for its intended purpose until a stable version is released.

At the current state of the application, this part of the application can only be accessed via browser.

---

<p align="center">
  <img src="/assets/logo.png" width="500"/>
</p>

## About this application

This application is to be used in combination with the client-side application **[QR-Tech-Client](https://github.com/logesixas96/QR-Tech-Client)**.  

The goal of this application is to allow an user to create an event inputting data such as time, date, and location to generate a unique qr-code that attendees, of the said event, can log their attendance.

---

## Compile From Source

In the event that the you would like to compile the program, perform the following steps.

### Install Flutter

#### Linux

```bash
# Install Flutter SDK and other dependencies
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev  
sudo snap install flutter --classic
flutter channel stable  # run this and below command if flutter was installed previously
flutter upgrade

# Pull code from repo and test/build
git clone https://github.com/logesixas96/QR-Tech-Host
cd QR-Tech-Host/
flutter run -d chrome  # run this for testing in debug mode
flutter build web
```

#### Windows

Ensure [Windows Powershell 5.0](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell) and the latest version of [Git](https://git-scm.com/download/win) is installed.

```powershell
# run in powershell to install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
```

If you wish to use flutter in the console, follow the steps [here](https://docs.flutter.dev/get-started/install/windows#update-your-path). We can now begin  cloning the repository and building the application.  

```powershell
git clone https://github.com/logesixas96/QR-Tech-Host
cd QR-Tech-Host/
flutter run -d chrome  # run this for testing in debug mode
flutter build web
```

---

**Important Note**: This program is licenced under GNU GPLv2

**side note**: This application was created as a project during our ([logesixas96](https://github.com/logesixas96) and [kshorenicholas](https://github.com/kshorenicholas)) internship. Future maintanence of these two repositories are yet to be decided.
