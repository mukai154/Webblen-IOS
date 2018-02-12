![Webblen-IOS](https://github.com/mukai154/Webblen-IOS/blob/master/resources/webblen-cover-img.png)

[![Crates.io](https://img.shields.io/crates/l/rustc-serialize.svg)]()
[![Platform](https://img.shields.io/badge/platform-IOS-lightgrey.svg)]()
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

# Webblen-IOS
Webblen's IOS App -- Be Rewarded for Attending Events Your Interested In

Downloading the Code
----------------
Make sure you have Xcode installed from 
the App Store. Then run the following two commands to install Xcode's
command line tools and `bundler`, if you don't have that yet.

```sh
[sudo] gem install bundler
xcode-select --install
```

The following commands will set up Webblen

```sh
git clone https://github.com/mukai154/Webblen-IOS.git
cd Webblen-IOS
pod install
```

Alrighty! We're ready to go!


## Getting Started

To get the app running, you need to follow these simple steps:

1. Open the Webblen-IOS workspace in Xcode.
2. Change the Bundle Identifier to match your domain.
3. Go to [Firebase](https://firebase.google.com) and create new project.

**NOTE: Webblen uses Firebase's Firestore for DB usage

4. Select "Add Firebase to your iOS app" option, type the bundle Identifier & click continue.
5. Download "GoogleService-Info.plist" file and add to the project. Make sure file name is "GoogleService-Info.plist".
6. Go to [Firebase Console](https://console.firebase.google.com), select your project, choose "Authentication" from left menu, select "SIGN-IN METHOD" and enable "Email/Password" option.
7. Open the terminal, navigate to project folder and run "pod update". 


## Set Environment Variables
Be sure to grab an IOS api key from [Google's Developer Console](https://code.google.com/apis/console)
Place the services key and places keys within AppDelegate.Swift
```sh
GMSServices.provideAPIKey("GMS-SERVICES-KEY")
GMSPlacesClient.provideAPIKey("GMS-PLACES-KEY")
```
If you're interested in Working with Facebook's API, be sure to define the ID within INFO.plst

Otherwise, you're now ready to run Webblen on your iPhone or the iOS Simulator.


## Whitepaper
Webblen is striving to create a social economy that leverages the steem blockchain to incentivize community participation
For more information, read the [Webblen Whitepaper](https://webblen.com/wp-content/uploads/2018/01/Webblen-White-Paper.pdf).

## Communication
If you have any questions or recommendations, feel free to either create a new issue or connect with us through [Discord](https://discord.gg/5cxGQmt) or [Telegram](https://t.me/joinchat/AAAAAEwPh5GOiHAZQ-QeJg)

Join Us in Creating the World's First Incentivized Attendance Software!

## License

Copyright 2018 Webblen

Licensed under [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0)
