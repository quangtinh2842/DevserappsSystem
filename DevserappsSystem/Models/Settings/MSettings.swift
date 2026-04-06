//
//  MSettings.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 25/03/2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

class MSettings: MBase {
  @objc dynamic var id: String?
  var appearance: String? //Light/Dark/Auto
  var language: String? // vi/en
  var sync: Sync?
  var notifications: Notifications?
  var about: About?
  
  var appFeedbacks: [Problem] = []
  var bugReports: [Problem] = []
  var helpAndSupportRequests: [Problem] = []
  
  override class func collectionName() -> String {
    return "settings_collection"
  }
  
  override class func primaryKey() -> String {
    return "id"
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> MBase? {
    return Mapper<MSettings>().map(JSONObject: jsonObject)
  }
  
  override init() { super.init() }
  
  init(settings: MSettings) {
    super.init()
    self.id = settings.id
    self.appearance = settings.appearance
    self.language = settings.language
    self.sync = settings.sync
    self.notifications = Notifications(notifications: settings.notifications)
    self.about = About(about: settings.about)
    self.appFeedbacks = settings.appFeedbacks
    self.bugReports = settings.bugReports
    self.helpAndSupportRequests = settings.helpAndSupportRequests
  }
  
  required init?(map: ObjectMapper.Map) {
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
  
  override func mapping(map: ObjectMapper.Map) {
    id                      <- map["id"]
    appearance              <- map["appearance"]
    language                <- map["language"]
    sync                    <- map["sync"]
    notifications           <- map["notifications"]
    about                   <- map["about"]
    appFeedbacks            <- map["appFeedbacks"]
    bugReports              <- map["bugReports"]
    helpAndSupportRequests  <- map["helpAndSupportRequests"]
  }
  
  override var description: String {
    return "<MSettings ID: \(self.id!)>"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if self.id == nil || self.id!.isEmpty {
      return (.InvalidId, "id")
    }
    
    return (.Valid, nil)
  }
}
