# Sample iOS App

## How to setup

Environments and tools:
----------------------

Xcode 10.2 or later

Carthage 0.33

Cocoapods 1.6.0

Swift 5

Development Target: iOS 11

Development Configured Environments: DEV - STAG - PROD

Text Editing - Identation:
```
  . Tab width: 2
  . Indent width: 2
  . Line wrapping: 2
```

XCode Preference -> Locations -> Command Line Tools: *Xcode 10.x* 

Required:
-------

Installing the following packages:

[Cocoapods](https://cocoapods.org/) : `sudo gem install cocoapods`

[Carthage](https://github.com/Carthage/Carthage) : `brew update & brew install carthage`

[Swiftlint](https://github.com/realm/SwiftLint) : `brew install swiftlint`

*Note: Cocoapods is not required for Sample proj, so please consider that whether it's necessary to install it or not. 
Cocoapods is convenient and easy to integrate and manage frameworks but we prefer Carthage mostly due to experienced many issues with Ruby package which is the core of cocoapods. Only using Pod to install frameworks if there is no choice.*

Setup:
-----

* Before setting the project up, you must ensure that all above requirements were up already. 

. Clone the repository to your machine <br>
. Navigate to iOSSample folder <br>
. Run the following CLIs one by one:  <br>
```
1. chmod +x ./build.sh
2. ./build.sh "NEW_PROJ_NAME"
```
replace NEW_PROJ_NAME with yours.

. Carthage: *carthage bootstrap --platform iOS --no-use-binaries* <br>
. Cocoapods: *pod install* if needed.

. Clear git history by following the [link](https://gist.github.com/stephenhardy/5470814)

Getting Started:
---------------

. Architecture: MVVM-Kit. <br>
. Code commentation followed Apple standard style.<br>
. In order to make the project going perfect with the architecture, **RxSwift** was preferred to use for binding data and UIs control.<br>
. The project was integrated **SwiftLint** for Swift style and conventions enforcement. All rules were declared in **.swiftlint.yml** file.

Document Generator:
---------
[Jazzy](https://github.com/realm/jazzy) - A command-line utility that generates documentation for Swift.

#### Install: `sudo gem install jazzy`

. Issue the following command to generate the project's documentation.

````
sh doc.sh
````

Frameworks:
----------

. [RxSwift](https://github.com/ReactiveX/RxSwift) - Reactive programming in Swift.

. [Alamofire](https://github.com/Alamofire/Alamofire) - Alamofire is an HTTP networking library written in Swift.

. [RxAlamofire](https://github.com/RxSwiftCommunity/RxAlamofire) - RxSwift wrapper around the elegant HTTP networking in Swift Alamofire

. [SwiftDate](https://github.com/malcommac/SwiftDate) - The best way to manage Dates and Timezones in Swift

. [Kingfisher](https://github.com/onevcat/Kingfisher) - A lightweight, pure-Swift library for downloading and caching images from the web.

. [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) - CryptoSwift is a growing collection of standard and secure cryptographic algorithms implemented in Swift 

. [AWS iOS SDK](https://github.com/aws-amplify/aws-sdk-ios) - The AWS SDK for iOS provides a library and documentation for developers to build connected mobile applications using AWS.

. [AWS AppSync SDK](https://github.com/awslabs/aws-mobile-appsync-sdk-ios) - The AWS AppSync SDK for iOS enables you to access your AWS AppSync backend and perform operations like Queries, Mutations, and Subscriptions. The SDK also includes support for offline operations.
