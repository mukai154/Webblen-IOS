![Webblen-IOS](https://github.com/mukai154/Webblen-IOS/blob/2.0.2/resources/webblen-cover-img.png)

[![Crates.io](https://img.shields.io/crates/l/rustc-serialize.svg)]()
[![Platform](https://img.shields.io/badge/platform-IOS-lightgrey.svg)]()
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

# Webblen-IOS
Webblen's IOS App -- Be Rewarded for Attending Events Your Interested In

## Getting Started

To get started and run the app, you need to follow these simple steps:

1. Open the Webblen-IOS workspace in Xcode.
2. Change the Bundle Identifier to match your domain.
3. Go to [Firebase](https://firebase.google.com) and create new project.
4. Select "Add Firebase to your iOS app" option, type the bundle Identifier & click continue.
5. Download "GoogleService-Info.plist" file and add to the project. Make sure file name is "GoogleService-Info.plist".
6. Go to [Firebase Console](https://console.firebase.google.com), select your project, choose "Authentication" from left menu, select "SIGN-IN METHOD" and enable "Email/Password" option.
7. Open the terminal, navigate to project folder and run "pod update". 
8. You're now ready to run Webblen on your iPhone or the iOS Simulator.


# Environment variables

There are quite a few environment variables that can be set to run steemd in different ways:

* `USE_WAY_TOO_MUCH_RAM` - if set to true, steemd starts a 'full node'
* `USE_FULL_WEB_NODE` - if set to true, a default config file will be used that enables a full set of API's and associated plugins.
* `USE_NGINX_FRONTEND` - if set to true, this will enable an NGINX reverse proxy in front of steemd that proxies websocket requests to steemd. This will also enable a custom healtcheck at the path '/health' that lists how many seconds away from current blockchain time your node is. It will return a '200' if it's less than 60 seconds away from synced.
* `USE_MULTICORE_READONLY` - if set to true, this will enable steemd in multiple reader mode to take advantage of multiple cores (if available). Read requests are handled by the read-only nodes, and write requests are forwarded back to the single 'writer' node automatically. NGINX load balances all requests to the reader nodes, 4 per available core. This setting is still considered experimental and may have trouble with some API calls until further development is completed.
* `HOME` - set this to the path where you want steemd to store it's data files (block log, shared memory, config file, etc). By default `/var/lib/steemd` is used and exists inside the docker container. If you want to use a different mountpoint (like a ramdisk, or a different drive) then you may want to set this variable to map the volume to your docker container.
