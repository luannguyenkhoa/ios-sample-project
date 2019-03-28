import AWSAppSync
import AWSS3

public struct AppSynClient {
  
  public static var shared = AppSynClient()
  public var appSyncClient: AWSAppSyncClient?
  public lazy var dbURL: URL = {
    // Reach the link for getting fimaliar with this initialization: https://aws-amplify.github.io/docs/ios/api#client-initialization
    let path = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask)[0]
    let dbURL = path.appendingPathComponent(AWSConfig.appsyncLocalDB.value)
    return dbURL
  }()
  
  /// Initilize AppSyncClient. We should call this after the authroization gets successed
  public mutating func initialize() {
    do {
      
      let cacheConfiguration = AWSAppSyncCacheConfiguration(from: dbURL)
      let appSyncServiceConfig = try AWSAppSyncServiceConfig()
      
      /* NOTE: In order to take advantage of AWS S3 auto uploading,
       we should generate the wrappers by passing the `--add-s3-wrapper` flag while running the code generator tool,
       otherwise AWSS3TransferUtility will not be cast to AWSS3ObjectManager and return nil
      */
      let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: appSyncServiceConfig,
                                                            cacheConfiguration: cacheConfiguration,
                                                            s3ObjectManager: AWSS3TransferUtility.default() as? AWSS3ObjectManager)
      appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
      
      // FIXME: we can change "id" to our Model primariry key name  respectively
      // Reach the link for more details: https://aws-amplify.github.io/docs/ios/api#client-architecture
      appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
    } catch {
      d_print(error.localizedDescription)
    }
  }
}
