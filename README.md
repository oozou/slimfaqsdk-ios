# SlimFAQSDK

[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SlimFAQSDK.svg?style=flat)](https://cocoapods.org/pods/SlimFAQSDK)
[![License](https://img.shields.io/cocoapods/l/SlimFAQSDK.svg?style=flat)](https://cocoapods.org/pods/SlimFAQSDK)
[![Platform](https://img.shields.io/cocoapods/p/SlimFAQSDK.svg?style=flat)](https://cocoapods.org/pods/SlimFAQSDK)

<img src="https://github.com/oozou/slimfaqsdk-ios/blob/master/screenshots/screencast_1.gif" width="267px"/>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 9.0 and above

## Installation

SlimFAQSDK is available through [CocoaPods](https://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods
To install it via CocoaPods, simply add the following line to your Podfile:
```ruby
pod 'SlimFAQSDK'
```

### Carthage
To install it via Carthage add following line to your Cartfile:
```ruby
github "oozou/slimfaqsdk-ios"
```

## Usage
```swift
// setup
SlimFAQSDK.shared.set(clientID: "slimwiki")

// present SlimFAQ screen using default presentation style
do {
    try SlimFAQSDK.shared.present(from: self, animated: true, completion: nil)
} catch {
    print("an error occured: \(error.localizedDescription)")
}

// or

// retrieve a viewcontroller instance for custom transition
if let vc = SlimFAQSDK.shared.instantiateFAQViewController() {
    // vc.transitioningDelegate = ...
    present(vc, animated: true, completion: nil)
}
```

## Author
Stanislau Baranouski, stan@oozou.com

## License

SlimFAQSDK is available under the MIT license. See the LICENSE file for more info.
