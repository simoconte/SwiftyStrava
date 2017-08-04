# Swify Strava

The Strava V3 API is a publicly available interface allowing developers access to the rich Strava dataset. 

This project is *not official* Strava library written in Swift. It supports read operations for all of the API endpoints and supports user activities upload.

- [Features](#features)
- [TODO](#todo)
- [Documentation](#documentation)
- [Dependencies](#dependencies)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
- [FAQ](#faq)
- [Credits](#credits)
- [License](#license)

## Features

- [x] 100% [Strava API](https://strava.github.io/api/) coverage
- [x] Most of Strava objects are modelled and ready for convenient usage
- [x] Networking is incapsulated and all heavy-Strava-lifting is done by the framework. So you can focus on your application functionality

## TODO

- [ ] Better error handling
- [ ] Sample application
- [ ] 100% Documentation coverage
- [ ] Generate Documentation
- [ ] Unit Tests
- [ ] Multiple file/data uploading options
- [ ] Distribute via [Cocoapods](https://cocoapods.org)

## Documentation

`StravaClient` have apple doc comments. You can check them in the code or using Xcode help hints (Alt + click on required method)

## Dependencies

SwiftyStrava has three external dependencies:

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
- [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)

## Requirements

- iOS 8.0+ / macOS 10.10+
- Xcode 8.1+
- Swift 3.0+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/swiftystrava). (Tag 'swiftystrava')
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SwiftyStrava into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "tristanhimmelman/AlamofireObjectMapper"
github "Hearst-DD/ObjectMapper"
github "limlab/SwiftStravaSDK"
```

Run `carthage update` to build the framework and drag the built `Strava.framework` into your Xcode project.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. CocoaPods is built with Ruby and is installable with the default Ruby available on OS X.

You can install CocoaPods using the following command:

```bash
$ sudo gem install cocoapods
```
Please refer to [official guide](https://guides.cocoapods.org/using/getting-started.html#installation) for more installation instructions.

To integrate SwiftyStrava into your Xcode project using CocoaPods, put these lines into your `Podfile`:

```ogdl
pod 'AlamofireObjectMapper', '~> 4.0'
pod 'SwiftyStrava', '~> 0.8'
```

Run `pod install` to fetch dependencies.

## Usage

### OAuth
1. Read [Strava API Docs (Authentication)](http://strava.github.io/api/v3/oauth/) 
2. Create your application account
	2.1. Create or login to your Strava account
	2.2. Create new application Using [Strava Developers Page](https://www.strava.com/settings/api)
	2.3. Remember `ClientID`, `Client Secret`
3. Create new Xcode project
	3.1 Open Xcode
	3.2 File -> New -> Project -> Single View Application -> Next
	3.3 Select some cool name for your project, select *Swift* as main project language. (Why do you need SwiftyStrava otherwise? :))
	3.4 
4. Follow the [Installation](#installation) chapter
5. Open your `AppDelegate` file
```swift
// Import framework
import Strava

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// ...
        // Setup `StravaClient`
        StravaClient.instance.configure(clientId: "<#Your Client Id#>", clientSecret: "<#Your Client Secret#>"")
        //...
        return true
    }
```

In any other file where you wish to read some Strava data:
```swift
// Import framework
import Strava

// ... 
func myAmazingFunction() {
	
    StravaClient.instance.retrieveAthlete(athleteId: <#Some athletes id#>) { athleteResponse in
        switch response {
            case .Success(let athlete):
                print("Hoorrray! Athlete data received")
                print(athlete)
            case .Failure(let err):
                print("Ouch! Something wrong happened. Probably this: \(err.message)")
            }
	}
}
```
6. Read [Strava API Docs](http://strava.github.io/api/v3/), because all the methods in the library are pretty much the same
7. Do not hesistate to [Communicate](#communication) 

## License

SwiftyStrava is released under the MIT license. See LICENSE for details.
