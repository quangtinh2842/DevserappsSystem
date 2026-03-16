import Foundation
import ObjectMapper

class Sync: NSObject, Mappable {
  @objc var settings: [Date] = []
  
  init(sync: Sync?) {
    self.settings = sync?.settings ?? []
  }
  
  required init?(map: Map) {
    let attributes: [String] = []
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: Map) {
    settings        <- (map["settings"], DateTransform())
  }
  
  func last() -> Date? {
    var all = [Date]()
    all.append(contentsOf: settings)
    all = all.sorted { $0 < $1 }
    return all.last
  }
}
