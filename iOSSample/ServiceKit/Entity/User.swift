public struct User: Codable {
  
  /// Basic user information
  public let username: String
  public var firstName: String?
  public var lastName: String?
  public let email: String
  public var apiKey = ""
  public let userId: Int
  
  public var fullName: String {
    return [firstName, lastName].compactMap({ $0 }).joined(separator: " ")
  }
  
  public init(username: String, email: String, userId: Int) {
    self.userId = userId
    self.username = username
    self.email = email
  }
  
  enum CodingKeys: String, CodingKey {
    case username, apiKey, email
    case userId = "id"
    case firstName = "first_name"
    case lastName = "last_name"
  }
}
