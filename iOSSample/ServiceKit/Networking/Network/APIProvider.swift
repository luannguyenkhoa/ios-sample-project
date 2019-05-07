
public struct APIProvider {
  
  public static func makeAuthAPI(baseURL: String) -> AuthAPI {
    return AuthAPI(network: Network<User>(baseURL: baseURL))
  }
}
