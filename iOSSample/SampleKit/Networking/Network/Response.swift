//
//  Response.swift
//  NetworkPlatform
//
//

internal enum Response {

  /// Request is success
  case success(Any)

  /// Response has error consists of Code, Message, Title
  case error(NetworkError?)

//  case redirect(String)
  /// Initialize NetworkStatus based on response's statusCode
  ///
  /// - Parameter statusCode: response's status code
  init(code: Int, data: Data) {
    switch code {
    case 200..<300:
      do {
        let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        self = .success(obj)
      } catch let err {
        self = .error(NetworkError(code: 403, message: err.localizedDescription, title: nil))
      }
    case 401: self = .error(NetworkError(code: code))
    default:
      self = .error(try? JSONDecoder().decode(NetworkError.self, from: data))
    }
  }
  
  init() {
    self = .error(nil)
  }
}
