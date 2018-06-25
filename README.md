# SlimFAQSDK

[![Version](https://img.shields.io/cocoapods/v/SlimFAQSDK.svg?style=flat)](https://cocoapods.org/pods/SlimFAQSDK)
[![License](https://img.shields.io/cocoapods/l/SlimFAQSDK.svg?style=flat)](https://cocoapods.org/pods/SlimFAQSDK)
[![Platform](https://img.shields.io/cocoapods/p/SlimFAQSDK.svg?style=flat)](https://cocoapods.org/pods/SlimFAQSDK)

<img src="https://github.com/oozou/slimfaqsdk-ios/blob/master/screenshots/slimfaq_1.png" width="267px"/>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 9.0 and above

## Installation

SlimFAQSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SlimFAQSDK'
```

## Usage

### CocoaPods
```swift
// setup
SlimFAQSDK.shared.set(clientID: "slimwiki")

// present SlimFAQ screen
do {
    try SlimFAQSDK.shared.present(from: self, animated: true, completion: nil)
} catch {
    print("an error occured: \(error.localizedDescription)")
}
```

### Carthage
// tbd

## Author

Stanislau Baranouski, stan@oozou.com

## License

SlimFAQSDK is available under the MIT license. See the LICENSE file for more info.
