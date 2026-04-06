//
//  MSystemTopic.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 13/03/2025.
//

import Foundation
import ObjectMapper

class MSystemTopic: MBase {
  
  override func validate() -> (ModelValidationError, String?) {
    return (.Valid, nil)
  }
  
  func mapObject(jsonObject: NSDictionary) -> MBase? {
    return Mapper<MSystemTopic>().map(JSONObject: jsonObject)!
  }
  
  @objc dynamic var systemTopicID: String?
  
  override init() { super.init() }
  
  required init?(map: ObjectMapper.Map) {
    super.init()
//    super.init(map: map)
  }
  
  override func mapping(map: ObjectMapper.Map) {
    systemTopicID <- map["systemTopicID"]
  }
  
  override class func collectionName() -> String {
    return "system_topics"
  }
  
  override class func primaryKey() -> String {
    return "systemTopicID"
  }

  override var description: String {
    return "<MSystemTopic ID: \(self.systemTopicID ?? "N/A")>"
  }
}
