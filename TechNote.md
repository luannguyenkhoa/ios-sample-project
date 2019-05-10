# Technical Notes:

## Description:

```
This project aims to be a standard configured code structure to help developers reducing the effort of Infracstructure period. 
It also collect all common services and implementations since we have experienced through a ton of iOS projects with full reliability of their output and being placed in ServiceKit. 
The most important part is the Kit, which will take both of Networking/AWS and Service implementations into the same place for the convenient use purpose and reduce compiling time as well as getting them isolated from other parts. 
Besides, another essential part is as looking at Scene folder that will store all App logics: every scene will be separated to 3 files: ViewController, ViewModel and Navigator.
Each of them will stand for its explicit mission in 3 types: view, logic and navigation, respectively. 
Note: ServiceKit is considered as a collection of ever implementations, so it might contain unnecessary parts for your needs. 
Please do review and remove those parts to get this initial project appropriated to yours. 
```
* Check out this [explanation](https://github.com/sergdort/CleanArchitectureRxSwift#application-1) to get more familiar with Scene concept 

## Structure Breaking Down

### iOSSample -> the project name
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

### ServiceKit
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

## CI/CD

*We will prefer CircleCI and Fastlane for CI/CD, combined with 2 services for UI Test and status notification: AWS Device Farm and Slack*

#### Preparation
1. Setup CircleCI
2. Add Environment Variables as listed out below:
  ```
  APPLE_TEAM_ID: xxxxxxx
  AWS_ACCESS_KEY_ID: xxxxxxx
  AWS_REGION: e.g: us-east-1
  AWS_SECRET_ACCESS_KEY: xxxxxx
  FASTLANE_PASSWORD: App Manager account password
  FASTLANE_USER: App Manager account email
  MATCH_GIT_REPO: a private git repo where will store certificates and provisioning profiles
  MATCH_KEYCHAIN_NAME: temporary keychain name: e.g: sample
  MATCH_KEYCHAIN_PASSWORD: temporary password for keychain permission
  MATCH_PASSWORD: password for cert encryption, should generate a strong password
  ```
3. Checkout SSH Keys: add ssh key to let circleci being able to clone certificates from git repo

#### AWS Device Farm for UI Test
1. Setup AWSDeviceFarm in us-west-2 region
2. Replace its name and device_pool to 2 respective fields in Fastfile

#### Slack Integration
1. Setup webhooks for both project internal and client Slack
2. Specify incomming message channels
3. Replace these ones to corresponding fields in Fastfile

#### Code Signing with Match
1. Set *codesigning_identity* in Fastfile: `iPhone Distribution: Team Name + (Team ID)`.<br>
e.g: *iPhone Distribution: Agility Company (N2KFAA234KI)* 

#### Rome for Carthage cache
1. Create S3 bucket for Rome cache
2. Replace Bucket name in Romefile
3. Update Romefile reposity map based on the Cartfile

## Tips

1. Using `d_print` to print out something in console instead of default `print` function
2. For S3TransferManagement, it's needed to configure essential parameters before doing upload/download by calling *AWSS3TransferManagement.shared.configS3(folder: "", bucketName: "", prefixURL: "")* from `AppDelegate`
3. Should clean up git history before pushing the project to your proj repository,
4. For AppSync codegen, we should use this [package](https://www.npmjs.com/package/aws-appsync-codegen) to generate code from graphql and schema instead of Amplify Codegen, because as our project usually seperates backend and frontend jobs explicitly,<br> backend will take care of initializing project on the cloud, but Amplify requires initializing before doing other jobs, this requirement makes a serious issue that automatically creating new project in the cloud<br> with multiple services: S3, IAM, CloudFormation. It's not a good behavior, and might issue duplicated and redudant stuffs.
5. Following this [article](https://medium.com/@dima.cheverda/xcode-9-templates-596e2ed85609) to create useful File templates
6. TBC....
