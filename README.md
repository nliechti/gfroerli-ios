
<p align="center">
    <img src="https://github.com/nliechti/gfroerli-ios/blob/main/Shared/Assets.xcassets/AppIcon.appiconset/AppIcon-ipad-83.5%402x.png" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/iOS-14.0+-blue.svg" />
    <img src="https://img.shields.io/badge/Swift-5.0-brightgreen.svg" />
    <a href="https://twitter.com/makram_95">
        <img src="https://img.shields.io/badge/Contact-@makram_95-lightgrey.svg?style=flat" alt="Twitter: @makram_95" />
    </a>
</p>

Gfrör.li is a project that allows people to see local watertemperatures in real-time.
We built sensors that measure the local temperature ever 15 minutes and send them to our back-end using the The Things Network.

Currently the following locations are available:

- Rapperswil: HSR Badewiese

*New locations will be added shortly!*


The Gför.li iOS app is currently available to test via [TestFlight](https://testflight.apple.com/join/7GpwFq86) and will be released to the AppStore soon!


# App

The app is intended to allow the user to see the current water temperature at their favorite locations at erverytime and everywhere. The structure of the app consists of multiple tabs, each of them having their own purpose.

## Architecture
The app is 100% coded in Swift and only uses the frameworks provided by the standard SDK. The UI is made with SwiftUI 2 only, hence the lowest supported iOS version is 14.0.
The fetching of data is implemented by normal REST calls to the backend.


## UI
<p align="center">
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Overview_EN.png" width="150"/>
    <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Favorites_EN.png" width="150"/>
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Lakeview_EN.png" width="150"/>
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/SensorView_EN.png" width="150"/>
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Darkmode_EN.png" width="150" />
</p>

### Overview
The overview screen is the landing page of the app and presents some quick options to the user.

### Water Body Overview
The Waterbody Overview shows a map of the water body with markers containing the current temperature at the corresponding locations. It also lists all sensors it contains.

### Location Overview
This view presents the user the current temperature, all-time record values, a history-graph to see the temperature-profiles of the last day, week and month. Addtionaly, it shows the sensor on a small map-view that allows the user to get the directions. At the end the user can see information about the sponsor of the sensor for this location.

### All
This View lists all available sensors and lets the user filter them using the search.

### Favorites
Here are the user sees all the locations he marked as favorite.

## Localization
The app is availble in these languages:
- English
- German
- Swiss-German
- French
- Italian
- Rumantsch

*If you find andy spelling or grammar mistakes, please contact me!*
## Privacy
Generally there is no userdata collected, except for:
- The email-adress and device info upon contacting us using the "Contact us" option in settings
- If allowed by the user, the crash and usage reports collected by iOS itself

