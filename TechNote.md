## Technical Notes:

```
This project aims to be a standard configured code structure to help developers reducing the effort on Infracstructure period. It also collect all common services and implementations since we have experienced throught a ton of iOS projects with full reliability of their output and being placed in SampleKit. The most important part is the kit, which will take both of Networking/AWS and Service implementations into the same place for the convenient use purpose and reduce compiling time as well as getting them isolated from other parts. Besides, another essential part is as looking at Scene folder that will store all App logics: every scene will be separated to 3 files: ViewController, ViewModel and Navigator. Each of them will stand for its explicit mission in 3 types: view, logic and navigation, respectively. 
Note: SampleKit is considered as a collection of ever implementations, so it might contain unnecessary parts for your needs. Please do review and remove those parts to get this initial project appropriated to yours. 
```

. Using `d_print` to print out something in console instead of default `print` function. <br/>
. For S3TransferManagement, it's needed to configure essential parameters before doing upload/download by calling `AWSS3TransferManagement.shared.configS3(folder: "", bucketName: "", prefixURL: "")` from AppDelegate <br/>
. TBC....
