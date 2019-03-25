# Sample iOS App

This project aims to be a standard configured code structure to help developers reducing the effort on Infracstructure period. It also collect all common services and implementations since we have done in iOS development with full of confidence of their accuracy and being placed in SampleKit. The most important part is the kit, which will gather both of Networking and Service implementations into the same place for the convenient use purpose and reduce compiling time as well as getting them isolated from other parts. Besides, looking at Scene folder that will store all App logics, every scene will be separated to 3 files: ViewController, ViewModel and Navigator. Each of them will have its explicit mission in 3 types: view, logic and navigation respectively. 
Note: SampleKit is considered as a collection of ever implementations, so it might contain unnecessary parts for your needs. Please do review and remove to those parts to get it appropriate to yours.

## How to setup

Environments and tools:
----------------------

Xcode 10 or later

Carthage 0.31.2

Cocoapods 1.5.3

Swift 4.2

Development Target: iOS 11

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
    `carthage update --platform iOS --no-use-binaries`
    
. Install pods: 
    `pod install`
    
Getting Started:
---------------

. Architecture: MVVM-Kit.

. Code commentation followed Apple standard style.

. In order to make the project going perfect with the architecture, `RxSwift` was preferred to use for binding data and UIs control.

. The project was integrated `SwiftLint` for Swift style and conventions enforcement. All rules were declared in .swiftlint.yml file.

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
