## Technical Notes:

### Description:

```
This project aims to be a standard configured code structure to help developers reducing the effort on Infracstructure period. 
It also collect all common services and implementations since we have experienced throught a ton of iOS projects with full reliability of their output and being placed in SampleKit. 
The most important part is the kit, which will take both of Networking/AWS and Service implementations into the same place for the convenient use purpose and reduce compiling time as well as getting them isolated from other parts. 
Besides, another essential part is as looking at Scene folder that will store all App logics: every scene will be separated to 3 files: ViewController, ViewModel and Navigator. 
Each of them will stand for its explicit mission in 3 types: view, logic and navigation, respectively. 
Note: SampleKit is considered as a collection of ever implementations, so it might contain unnecessary parts for your needs. 
Please do review and remove those parts to get this initial project appropriated to yours. 
```

### Breaking Down Structure

1.	iOSSample
```
. Config:
  . Config: For App configurations with seperated env
  . Constant: For App constant values

. Utility: Gather all common and shared components, logics, functionabilities
  . Resource: App extend resource: image, fonts,...
  . Shared Components: gather all shared components such as custom view, custom alert,...
  . Enum: In Swift, we prefer enum for most cases of defining certain contents such as Message, Title, texts, storyboad names,... 
    So place the strings to corresponding enum in there is required. See SignIn, SignUp scene to get to know how to use
  . Ext: for placing extensions
  . Help: Common functionabilities related to Cocoa, e.g: query viewcontroller from storyboard,...
  . Localization: For storing localized strings files
  . Service: App services such as Analytics, build delivery services,...
  . Util: Common utilities, e.g: convert number, format currency,...
  
. Common: Place for Base Inheritable components of viewcontroller, viewmodel along with required viewmodel format type
. Application: For initializing and persist reusable properties and configure the main interface when the app gets launched 
. Scene: Place for the whole App implementations, particularly storing ViewController, ViewModel and Navigator for each scene.
. View: Separated to be 2 parts: 
  . IB for storing all necessary storyboard files
  . Subclass for storing all custom view - subclass - of scenes, e.g: cusom TableViewCell, CollectionViewCell, scene specified custom view,...
. Support Files: For storing Project compulsary files: AppDelegate, Assets, Info.plist
```

2. SampleKit
```
. AWS:
  . Config: Storing all things related AWS, specified in parameters, e.g: custom error, local database name,...
  . Authorization: A wrapper for AWS authorization by taking use of AWSMobileClient with full of necessary functionabilities
  . Client: Storing all AWS client instances, e.g: S3, AppSync,...
  . API: Place for storing AppSync APIs after generating with AWS Amplify codegen

. Entity: Place of all necessary entities, e.g: User, Post,...
. Networking: Place of all implementation playing with Rest API, following the example to import your own ones.
. Service: Place of all reusable, convenient iOS services, including extensions, utilities,... which has got the taking-over certificate of the accuracy
  e.g: . Date management is for convering most common datetime handlers
       . Location is for handling User location serivce
       . LocalNotification is for handling User Local Notification from register to fire a notification
       .... The more you explore, the more you obtain.
```

### Recommendation

1. Using `d_print` to print out something in console instead of default `print` function
2. For S3TransferManagement, it's needed to configure essential parameters before doing upload/download by calling *AWSS3TransferManagement.shared.configS3(folder: "", bucketName: "", prefixURL: "")* from `AppDelegate`
3. TBC....
