# Sample iOS App

## How to setup

Environments and tools:
----------------------

Xcode 10 or later

Carthage 0.31.2

Cocoapods 1.5.3

Swift 4.2

Development Target: iOS 11

Development Configured Environments: DEV - STAGING - PROD


Required:
-------

Installing the following packages:

[Cocoapods](https://cocoapods.org/) : `sudo gem install cocoapods`

[Carthage](https://github.com/Carthage/Carthage) : `brew update & brew install carthage`

[Swiftlint](https://github.com/realm/SwiftLint) : `brew install swiftlint`

Setup:
-----

* Before setting the project up, you must ensure that all above requirements were up already.

. Clone the repository to your machine

. Navigate to iOSSample folder

. Update Carthage: 
    `carthage update --platform iOS --no-use-binaries` <br/>
    ```
    Trick to resolve if getting error: `failed with exit code 128:` -> comment out `aws-mobile-appsync-sdk-ios` from Cartfile, then run the above line to build frameworks. 
    After it's done, uncomment `appsync` line, run this command: `carthage update --no-build-binaries --no-build`, 
    waiting until it gets done then run the last one: carthage build `aws-mobile-appsync-sdk-ios --platform iOS`
    ```

. Install pods: 
    `pod install`

. SDK Setup: <br/>
    * AWS: Following this [guideline](https://aws-amplify.github.io/docs/ios/manualsetup) to get the SDK worked in your project <br/>
    * AWS AppSync SDK: following this [section](https://github.com/awslabs/aws-mobile-appsync-sdk-ios#via-carthage).

Getting Started:
---------------

. Architecture: MVVM-Kit.

. Code commentation followed Apple standard style.

. In order to make the project going perfect with the architecture, `RxSwift` was preferred to use for binding data and UIs control.

. The project was integrated `SwiftLint` for Swift style and conventions enforcement. All rules were declared in **.swiftlint.yml** file.

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
