# web_qr_system

:warning: **IMPORTANT NOTE**: This application is still **in development** and should **not** be used for its intended purpose until a stable version is released.

At the current state of the application, this part of the application can only be accessed via browser.

---

<p align="center">
  <img src="/assets/logo.png" width="500"/>
</p>

## About this application

This application is to be used in combination with the client-side application **[Android-QR-System](https://github.com/logesixas96/Android-QR-System)**.  

The goal of this application is to allow an user to create an event inputting data such as time, date, and location to generate a unique qr-code that attendees, of the said event, can log their attendance.

---

## Compile From Source

In the event that the you would like to compile the program, perform the following steps.

### Install Flutter

#### Linux

```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev  # additional dependencies for Flutter SDK
sudo snap install flutter --classic
flutter channel stable  # run this and below command if flutter was installed previously
flutter upgrade
git clone https://github.com/logesixas96/QR-Tech-Host
cd QR-Tech-Host
flutter run -d chrome  # runs in debug mode for testing
flutter build web
```

#### Windows


```text
git clone https://github.com/logesixas96/QR-Tech-Host
 

```

---
**side note**: This application was created as a project during our ([logesixas96](https://github.com/logesixas96) and [kshorenicholas](https://github.com/kshorenicholas)) internship. Future maintanence of these two repositories are yet to be decided.
