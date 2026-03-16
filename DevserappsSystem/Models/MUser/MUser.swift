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
import RealmSwift

class MUser: Object, Mappable {
  @objc dynamic var uid: String? = ""
  var providerID: String?
  var displayName: String?
  var email: String?
  var photoURL: URL?
  var name: Name?
  var dateOfBirth: Date?
  var address: Address?
  var phoneNumber: PhoneNumber?
  var settingsID: String?
  
  class func collectionName() -> String {
    return "synced_users"
  }
  
  override class func primaryKey() -> String {
    return "uid"
  }
  
  class func mapObject(jsonObject: NSDictionary) -> MUser? {
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
    let attributes = ["uid", "providerID"]
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: ObjectMapper.Map) {
    uid         <- map["uid"]
    providerID  <- map["providerID"]
    displayName <- map["displayName"]
    email       <- map["email"]
    photoURL    <- (map["photoURL"], URLTransform())
    
    // more custom
    name        <- map["name"]
    dateOfBirth <- (map["dateOfBirth"], DateTransform())
    address     <- map["addressID"]
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
    
    if self.photoURL?.absoluteString != user?.photoURL?.absoluteString {
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
  
  func validate() -> (ModelValidationError, String?) {
    if self.uid == nil || self.providerID == nil {
      return (.InvalidId, "uid, providerID")
    }
    
    if self.dateOfBirth?.isFuture() ?? false {
      return (.InvalidTimestamp, "dateOfBirth")
    }
    
    return (.Valid, nil)
  }
  
  class func allUsersExceptCurrent(completion handler: @escaping CollectionQueryResultHandler2) {
    MUser.query { (results, error) in
      if error != nil {
        handler([:], error)
      } else {
        let currentUser = Auth.auth().currentUser
        let usersExceptCurrent = results.filter { $0.value["uid"] as? String != currentUser?.uid }
        handler(usersExceptCurrent, nil)
      }
    }
  }
}

extension MUser {
  // Read
  class func find(byId objectId: String, completion handler: @escaping ObjectQueryResultHandler2) {
    let dbRef = Database.database().reference()
    let collectionName = self.collectionName()
    
    let query = dbRef.child("\(collectionName)/\(objectId)")
    
    query.observe(.value) { snapshot in
      if !(snapshot.value is NSDictionary) {
        handler(nil, NotFoundError)
      } else {
        let resultDict = snapshot.value as! NSDictionary
        handler(resultDict, nil)
      }
    } withCancel: { error in
      handler(nil, error)
    }
  }
  
  class func query(withClause queryClause: [QueryClausesEnum: AnyObject]? = nil,
                   completion handler: @escaping CollectionQueryResultHandler2) {
    let dbRef = Database.database().reference()
    let collectionName = self.collectionName()
    
    var query = dbRef.child(collectionName) as DatabaseQuery
    
    if queryClause != nil {
      if let orderedChildKey = queryClause![.OrderedChildKey] {
        query = query.queryOrdered(byChild: orderedChildKey as! String)
      }
      
      if let startValue = queryClause![.StartValue] {
        query = query.queryStarting(atValue: startValue)
      }
      
      if let endValue = queryClause![.EndValue] {
        query = query.queryEnding(atValue: endValue)
      }
      
      if let exactValue = queryClause![.ExactValue] {
        query = query.queryEqual(toValue: exactValue)
      }
    }
    
    query.observeSingleEvent(of: .value) { snapshot in
      if !(snapshot.value is NSDictionary) {
        handler([:], NotFoundError)
      } else {
        let results = snapshot.value as! [String: NSDictionary]
        handler(results, nil)
      }
    } withCancel: { error in
      handler([:], error)
    }
  }
  
  // Write
  func save(completion handler: UpdateValueHandler? = nil) throws -> String {
    let (validation, errors) = self.validate()
    let errorDomain = "Model validation failed"
    
    switch validation {
    case .Valid: break
    case .InvalidId:
      throw NSError(domain: errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "IDs \(errors!) must not be blank"])
    case .InvalidTimestamp:
      throw NSError(domain: errorDomain, code: -2, userInfo: [NSLocalizedDescriptionKey: "Timestamps \(errors!) must not be blank"])
    case .InvalidBlankAttribute:
      throw NSError(domain: errorDomain, code: -3, userInfo: [NSLocalizedDescriptionKey: "Attributes \(errors!) must not be blank"])
    }
    
    let dbRef = Database.database().reference()
    let collectionName = type(of: self).collectionName()
    let primaryKey = type(of: self).primaryKey()
    
    var objectId: String
    
    if let primaryKeyValue = (self.value(forKey: primaryKey) as? String) {
      objectId = self._saveAsUpdate(inDb: dbRef, inCollection: collectionName, withId: primaryKeyValue, completion: handler)
    } else {
      objectId = try self._saveAsNew(inDb: dbRef, inCollection: collectionName, withPrimaryKey: primaryKey, completion: handler)
    }
    
    return objectId
  }
  
  private func _saveAsUpdate(inDb dbRef: DatabaseReference, inCollection colName: String, withId objectId: String, completion handler: UpdateValueHandler?) -> String {
    let objectJson = self.toJSON()
    let updatesManifest = ["/\(colName)/\(objectId)": objectJson]
    
    if handler != nil {
      dbRef.updateChildValues(updatesManifest, withCompletionBlock: handler!)
    } else {
      dbRef.updateChildValues(updatesManifest)
    }
    
    return objectId
  }
  
  private func _saveAsNew(inDb dbRef: DatabaseReference, inCollection colName: String, withPrimaryKey primaryKey: String, completion handler: UpdateValueHandler?) throws -> String {
    guard let objectId = dbRef.child(colName).childByAutoId().key else {
      let errorDomain = "Firebase database"
      throw NSError(domain: errorDomain, code: -101, userInfo: [NSLocalizedDescriptionKey: "Couldn't generate auto ID key for new object"])
    }
    
    var objectJson = self.toJSON()
    objectJson[primaryKey] = objectId
    
    let updatesManifest = ["/\(colName)/\(objectId)": objectJson]
    
    if handler != nil {
      dbRef.updateChildValues(updatesManifest, withCompletionBlock: handler!)
    } else {
      dbRef.updateChildValues(updatesManifest)
    }
    
    return objectId
  }
}
