//
//  MSystem.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 13/03/2025.
//

import Foundation
import ObjectMapper

class MSystem: MBase {
  @objc dynamic var id: String?
  var displayName: String?
  var photoURL: String?
  var address: Address?
  var name: String?
  
  var getPhotoURL: URL? {
    if photoURL == nil {
      return nil
    } else {
      return URL(string: photoURL!)
    }
  }
  
  override class func collectionName() -> String {
    return "system_collection"
  }
  
  override class func primaryKey() -> String {
    return "id"
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> MBase? {
    return Mapper<MSystem>().map(JSONObject: jsonObject)
  }
  
  override init() { super.init() }
  
  init(systemParam: MSystem) {
    super.init()
    self.id = systemParam.id
    self.displayName = systemParam.displayName
    self.photoURL = systemParam.photoURL
    self.address = systemParam.address
    self.name = systemParam.name
  }
  
  required init?(map: Map) {
    super.init()
//    super.init(map: map)
    
    let attributes = ["id", "name"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  override func mapping(map: Map) {
    id            <- map["id"]
    displayName   <- map["displayName"]
    photoURL      <- map["photoURL"]
    address     <- map["address"]
    name          <- map["name"]
  }
  
  override var description: String {
    return "<MSystem Id: \(self.id!) - Name: \(self.name ?? "N/A")>"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if self.id == nil || self.id!.isEmpty {
      return (.InvalidId, "id")
    }
    
    if self.name == nil || self.name!.isEmpty {
      return (.InvalidBlankAttribute, "name")
    }
    
    return (.Valid, nil)
  }
  
  func isDifferent(from system: MSystem?) -> Bool {
    if self.id != system?.id {
      return true
    }
    
    if self.displayName != system?.displayName {
      return true
    }
    
    if self.photoURL != system?.photoURL {
      return true
    }
    
    if let address = self.address,
       address.isDifferent(from: system?.address) {
      return true
    } else if let address = system?.address,
              address.isDifferent(from: self.address) {
      return true
    }
    
    if self.name != system?.name {
      return true
    }
    
    return false
  }
  
  class func allSystemsForCurrentUser(completion handler: @escaping CollectionQueryResultHandler) {
    let currentUser = UserStore.currentUser
    
    let queryClause: [QueryClausesEnum: AnyObject] = [
      .OrderedChildKey: currentUser!.uid! as AnyObject,
      .ExactValue: true as AnyObject,
    ]
    
    MSystemTopic.query(withClause: queryClause) { results, error in
      if error != nil {
        handler([], error)
        return
      }
      
      let topics = results as! [MSystemTopic]
      let systemIds = topics.filter { $0.systemTopicID != nil }.map { $0.systemTopicID! }
      
      if systemIds.isEmpty {
        handler([], NotFoundError)
        return
      }
      
      let uniqueSystemIdsSet = Set<String>(systemIds)
      let uniqueSystemIds = [String](uniqueSystemIdsSet).sorted()
      
      self.retrieveTopicSystems(fromIds: uniqueSystemIds, completion: handler)
    }
  }
  
  class func retrieveTopicSystems(fromIds systemIds: [String], completion handler: @escaping CollectionQueryResultHandler) {
    let queryClause: [QueryClausesEnum: AnyObject] = [
      .OrderedChildKey: "id" as AnyObject,
      .StartValue: systemIds.first! as AnyObject,
      .EndValue: systemIds.last! as AnyObject
    ]
    
    self.query(withClause: queryClause) { (systems, error) in
      if error != nil {
        handler([], error)
      } else {
        handler(systems, nil)
      }
    }
  }
}
