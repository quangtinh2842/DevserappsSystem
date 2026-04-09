//
//  MSystem.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 13/03/2025.
//

import Foundation
import ObjectMapper

enum SystemCategories: String {
  case Home = "Home"
  case Tank = "Tank"
  case Other = "Other"
}

class MSystem: MBase {
  @objc dynamic var id: String?
  @objc dynamic var uid: String?
  var displayName: String?
  var photoURL: String?
  var address: Address?
  var category: String?
  
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
    self.uid = systemParam.uid
    self.displayName = systemParam.displayName
    self.photoURL = systemParam.photoURL
    self.address = systemParam.address
    self.category = systemParam.category
  }
  
  required init?(map: Map) {
    super.init()
//    super.init(map: map)
    
    let attributes = ["id"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  override func mapping(map: Map) {
    id            <- map["id"]
    uid           <- map["uid"]
    displayName   <- map["displayName"]
    photoURL      <- map["photoURL"]
    address       <- map["address"]
    category      <- map["category"]
  }
  
  override var description: String {
    return "<MSystem Id: \(self.id!)>"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if self.id == nil || self.id!.isEmpty ||
        self.uid == nil || self.uid!.isEmpty {
      return (.InvalidId, "id, uid")
    }
    
    if self.category == nil || self.category!.isEmpty {
      return (.InvalidBlankAttribute, "category")
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
    
    return false
  }
  
  class func allSystemsForCurrentUser(completion handler: @escaping CollectionQueryResultHandler) {
    let currentUser = UserStore.currentUser
    
    let queryClause: [QueryClausesEnum: AnyObject] = [
      .OrderedChildKey: "uid" as AnyObject,
      .ExactValue: currentUser!.uid! as AnyObject,
    ]
    
    MSystem.query(withClause: queryClause) { results, error in
      if let error = error {
        handler([], error)
      } else {
        handler(results, nil)
      }
    }
  }
}
