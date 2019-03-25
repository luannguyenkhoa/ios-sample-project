public struct NetworkError: Decodable {
  
  public var code: Int = 400
  public var message: String?
  public var title: String?
  
  public init(code: Int, message: String? = nil, title: String? = nil) {
    self.code = code
    self.message = message
    self.title = title
  }
  
  enum CodingKeys: String, CodingKey {
    case code, title
    case message = "error"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    code    <~ (values, .code)
    title   <~ (values, .title)
    message <~ (values, .message)
  }
}
