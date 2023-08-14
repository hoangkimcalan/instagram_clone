<h1 align="center">Welcome to instagram_clone 👋</h1>
<p align="center">
  <img src="https://img.shields.io/badge/flutter_dart-version_3.10.6-blue?link=https%3A%2F%2Fflutter.dev%2F" />
  <a href="https://firebase.google.com/">
    <img src="https://img.shields.io/badge/firebase-version_10.1.0-blue?link=https%3A%2F%2Fflutter.dev%2F" />
  </a>
  <a href="https://www.facebook.com/QuynC49">
    <img alt="Facebook: Cả Hoàng Kim" src="https://img.shields.io/badge/Ca_Hoang_Kim-Face_book?link=https%3A%2F%2Fwww.facebook.com%2FQuynC49" target="_blank" />
  </a>
</p>

> CLI that generates beautiful README.md files.<br /> `readme-md-generator` will suggest you default answers by reading your `package.json` and `git` configuration.

## ✨ Demo

`instagram-clone` is an app like instagram real has features: upload post, comment, chating, selfie, short clip and view many images to see beautiful girl 😁

<p align="center">
  <img width="300" height="700" align="center" src="https://im5.ezgif.com/tmp/ezgif-5-998f1efbb4.gif" alt="demo"/>
</p>

Generated `README.md`:

Example of `pubspec.yaml` with good meta data:

```jpubspec.yaml
// The pubspec.yaml is not required to run Instagram_clone
{
  name: instagram_clone
description: A new Flutter project.
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: '>=2.19.4 <3.0.0'

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  cached_network_image: ^3.2.3
  cloud_firestore: ^4.8.1
  cupertino_icons: ^1.0.2
  emoji_picker_flutter: ^1.6.1
  firebase_auth: ^4.6.3
  firebase_core: ^2.14.0
  firebase_messaging: ^14.6.5
  firebase_storage: ^11.2.3
  flutter:
    sdk: flutter
  flutter_notification_channel: ^2.0.0
  flutter_staggered_grid_view: ^0.6.2
  flutter_svg: ^2.0.5
  http: ^0.13.6
  image_picker: ^0.8.9
  intl: ^0.18.1
  provider: ^6.0.5
  qr_flutter: ^4.0.0
  uuid: ^3.0.7

dev_dependencies:
  flutter_lints: ^2.0.0
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: "^0.13.1"

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/playstore.png"

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec
# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/ic_instagram.svg
    - assets/notfound.png
  #   - images/a_dot_ham.jpeg
  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware
  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages
  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages

}

```
## Getting started


#### 1. [Setup Flutter](https://flutter.io/setup/)

#### 2. Clone the repo

```sh
$ git clone https://github.com/hoangkimcalan/instagram_clone
$ cd Instagram-clone
```

#### 3. Setup the firebase app

1. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
2. Once your Firebase instance is created, you'll need to enable anonymous authentication.

* Go to the Firebase Console for your new instance.
* Click "Authentication" in the left-hand menu
* Click the "sign-in method" tab
* Click "Google" and enable it


4. Enable the Firebase Database
* Go to the Firebase Console
* Click "Database" in the left-hand menu
* Click the Cloudstore "Create Database" button
* Select "Start in test mode" and "Enable"

5. (skip if not running on Android)

* Create an app within your Firebase instance for Android, with package name com.mohak.instagram
* Run the following command to get your SHA-1 key:

```
keytool -exportcert -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
```

* In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
* Follow instructions to download google-services.json
* place `google-services.json` into `/android/app/`.


6. (skip if not running on iOS)

* Create an app within your Firebase instance for iOS, with your app package name
* Follow instructions to download GoogleService-Info.plist
* Open XCode, right click the Runner folder, select the "Add Files to 'Runner'" menu, and select the GoogleService-Info.plist file to add it to /ios/Runner in XCode
* Open /ios/Runner/Info.plist in a text editor. Locate the CFBundleURLSchemes key. The second item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist

Double check install instructions for both
   - Google Auth Plugin
     - https://pub.dartlang.org/packages/firebase_auth
   - Firestore Plugin
     -  https://pub.dartlang.org/packages/cloud_firestore

## 🚀 Usage


Just run the following command at the root of your project and answer questions:

```sh
flutter pub get
flutter run
```

Or use default values for all questions (`-y`):
Flutter run Or use in IDE
Run without debug - Ctrl + F5

## Code Contributors

This project made and power by HoangKimCa.
<br />
<a href="https://github.com/hoangkimcalan"><img src="https://avatars.githubusercontent.com/u/34814759?v=4" width="150" height="150" /></a>


## Show your support

Please ⭐️ this repository if this project helped you!

## 📝 License

Copyright © 2023 [Hoang Kim Ca](https://github.com/hoangkimcalan).<br />

---

_This README was generated with ❤️ 
