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
- [Donations](#donations)
- [License](#license)

## Features

- [x] 100% [Strava API](https://strava.github.io/api/) coverage
- [x] Generate Documentation
- [x] Most of Strava objects are modelled and ready for convenient usage
- [x] Networking is incapsulated and all heavy-Strava-lifting is done by the framework. So you can focus on your application functionality

## TODO

- [ ] 100% Documentation coverage
- [ ] Unit Tests
- [ ] Multiple file/data uploading options

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
github "limlab/SwiftyStrava"
```

Run `carthage update` to build the framework and drag the built `Strava.framework` into your Xcode project.

### Manually

## Usage

## FAQ

## Credits

## Donations

## License

SwiftyStrava is released under the MIT license. See LICENSE for details.