enum AWSConfig {
  
  case appsyncLocalDB
  
  var value: String {
    switch self {
    default:
      return String(describing: self)
    }
  }
  
}
