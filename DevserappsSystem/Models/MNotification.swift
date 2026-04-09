//
//  MNotification.swift
//  DevserappsSystem
//
//  Created by Soren Inis Ngo on 08/04/2026.
//

import Foundation
import ObjectMapper

class MNotification: MBase {
  @objc var nid: String?
  @objc var uid: String?
  @objc var iconURL: String?
  @objc var title: String?
  @objc var content: String?
  @objc var time: Date?
  @objc var wasRead: Bool = false
  
  override class func collectionName() -> String {
    return "notifications"
  }
  
  override class func primaryKey() -> String {
    return "nid"
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> MBase? {
    return Mapper<MNotification>().map(JSONObject: jsonObject)
  }
  
  required init?(map: ObjectMapper.Map) {
    super.init()
    
    let attributes = [String]()
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  override func mapping(map: ObjectMapper.Map) {
    nid         <- map["nid"]
    uid         <- map["uid"]
    iconURL     <- map["iconURL"]
    title       <- map["title"]
    content     <- map["content"]
    time        <- (map["time"], DateTransform())
    wasRead     <- map["wasRead"]
  }
  
  override var description: String {
    return "<MNotification Id: \(self.nid!)>"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    return (.Valid, nil)
  }
  
  class func allNotificationsForCurrentUser(completion handler: @escaping CollectionQueryResultHandler) {
    let currentUser = UserStore.currentUser
    
    let queryClause: [QueryClausesEnum: AnyObject] = [
      .OrderedChildKey: "uid" as AnyObject,
      .ExactValue: currentUser!.uid! as AnyObject,
    ]
    
    MNotification.query(withClause: queryClause) { results, error in
      if error != nil {
        handler([], error)
        return
      }
      
      handler(results, nil)
    }
  }
}
