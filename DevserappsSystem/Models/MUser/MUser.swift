// Reference: https://bitbucket.org/edm-courses/edm-01-ios-beginners/src/master/secret-messenger/secret-messenger/models/MBase.swift

//
//  MUser.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 05/03/2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

class MUser: MBase {
  @objc var uid: String?
  @objc var providerID: String?
  @objc var displayName: String?
  @objc var email: String?
  @objc var photoURL: String?
  @objc var name: Name?
  @objc var dateOfBirth: Date?
  @objc var address: Address?
  @objc var phoneNumber: PhoneNumber?
  @objc var settingsID: String?
  
  var getPhotoURL: URL? {
    if photoURL == nil {
      return nil
    } else {
      return URL(string: photoURL!)
    }
  }
  
  override class func collectionName() -> String {
    return "synced_users"
  }
  
  override class func primaryKey() -> String {
    return "uid"
  }
  
  override class func mapObject(jsonObject: NSDictionary) -> MBase? {
    return Mapper<MUser>().map(JSONObject: jsonObject)
  }
  
  class func syncFromCurrentUser(completion handler: @escaping UpdateValueHandler) throws {
    guard let currentUser = Auth.auth().currentUser else { return }
    
    let syncedUser = MUser()
    let attributes = ["uid", "displayName", "email", "photoURL"]
    
    for attribute in attributes {
      if let value = currentUser.value(forKey: attribute) {
        syncedUser.setValue(value, forKey: attribute)
      }
    }
    
    if let provider = currentUser.providerData.first {
      syncedUser.providerID = provider.providerID
    }
    
    let _ = try syncedUser.save(completion: handler)
  }
  
  class func logOutEverywhere(completion handler: ((Error?) -> ())? = nil) {
    do {
      try Auth.auth().signOut()
      if handler != nil { handler!(nil) }
    } catch {
      if handler != nil { handler!(error) }
    }
  }
  
  override init() { super.init() }
  
  init(user: MUser) {
    super.init()
    self.uid = user.uid
    self.providerID = user.providerID
    self.displayName = user.displayName
    self.email = user.email
    self.photoURL = user.photoURL
    self.name = user.name
    self.dateOfBirth = user.dateOfBirth
    self.address = user.address
    self.phoneNumber = user.phoneNumber
    self.settingsID = user.settingsID
  }
  
  required init?(map: ObjectMapper.Map) {
    super.init()
    
    let attributes = ["uid", "providerID"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  override func mapping(map: ObjectMapper.Map) {
    uid         <- map["uid"]
    providerID  <- map["providerID"]
    displayName <- map["displayName"]
    email       <- map["email"]
    photoURL    <- map["photoURL"]
    
    // more custom
    name        <- map["name"]
    dateOfBirth <- (map["dateOfBirth"], DateTransform())
    address     <- map["address"]
    phoneNumber <- map["phoneNumber"]
    settingsID  <- map["settingsID"]
  }
  
  func isDifferent(from user: MUser?) -> Bool {
    if self.uid != user?.uid {
      return true
    }
    
    if self.providerID != user?.providerID {
      return true
    }
    
    if self.displayName != user?.displayName {
      return true
    }
    
    if self.email != user?.email {
      return true
    }
    
    if self.photoURL != user?.photoURL {
      return true
    }
    
    if self.name != user?.name {
      return true
    }
    
    if self.dateOfBirth?.ddMMyyyy() != user?.dateOfBirth?.ddMMyyyy() {
      return true
    }
    
    if let address = self.address,
       address.isDifferent(from: user?.address) {
      return true
    } else if let address = user?.address,
              address.isDifferent(from: self.address) {
      return true
    }
    
    if let phoneNumber = self.phoneNumber,
       phoneNumber.isDifferent(from: user?.phoneNumber) {
      return true
    } else if let phoneNumber = user?.phoneNumber,
              phoneNumber.isDifferent(from: self.phoneNumber) {
      return true
    }
    
    if self.settingsID != user?.settingsID {
      return true
    }
    
    return false
  }
  
  override var description: String {
    return "<MUser Id: \(self.uid!) - Display name: \(self.displayName ?? "N/A")>"
  }
  
  override func validate() -> (ModelValidationError, String?) {
    if self.uid == nil || self.providerID == nil {
      return (.InvalidId, "uid, providerID")
    }
    
    if self.dateOfBirth?.isFuture() ?? false {
      return (.InvalidTimestamp, "dateOfBirth")
    }
    
    return (.Valid, nil)
  }
  
  class func allUsersExceptCurrent(completion handler: @escaping (Error?, [MUser]) -> Void) {
    MUser.query { (results, error) in
      if error != nil {
        handler(error, [])
      } else {
        let currentUser = Auth.auth().currentUser
        let allUsers = results as! [MUser]
        let usersExceptCurrent = allUsers.filter { $0.uid != currentUser?.uid }
        handler(nil, usersExceptCurrent)
      }
    }
  }
}
