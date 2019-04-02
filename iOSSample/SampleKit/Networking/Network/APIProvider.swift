
public struct APIProvider {
  
  public static func makeSampleAPI(baseURL: String) -> SampleAPI {
    return SampleAPI(network: Network<User>(baseURL: baseURL))
  }
}
