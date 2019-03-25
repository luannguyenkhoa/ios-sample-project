public struct Meta: Codable {
  
  public let limit: Int
  public let offset: Int
  public let totalCount: Int
  
  enum CodingKeys: String, CodingKey {
    case limit, offset
    case totalCount = "total_count"
  }
}
