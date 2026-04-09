// Link: https://bitbucket.org/edm-courses/edm-01-ios-beginners/src/master/secret-messenger/secret-messenger/models/MBase.swift

//
//  MBase.swift
//  secret-messenger
//
//  Created by Ethan Nguyen on 6/12/16.
//  Copyright © 2016 Thanh Nguyen. All rights reserved.
//

//  Edited by Tịnh Ngô

import Foundation
import FirebaseDatabase
import ObjectMapper

class MBase: NSObject, Mappable {
  class func collectionName() -> String {
    fatalError("This method must be overridden")
  }
  
  class func primaryKey() -> String {
    fatalError("This method must be overridden")
  }
  
  class func mapObject(jsonObject: NSDictionary) -> MBase? {
    fatalError("This method must be overridden")
  }
  
  override init() {}
  
  required init?(map: ObjectMapper.Map) {
    fatalError("This method must be overridden")
  }
  
  func mapping(map: ObjectMapper.Map) {
    fatalError("This method must be overridden")
  }
  
  func validate() -> (ModelValidationError, String?) {
    fatalError("This method must be overridden")
  }
  
  class func findAsync(byId objectId: String) async throws -> MBase? {
    return try await withCheckedThrowingContinuation { continuation in
      findOneTime(byId: objectId) { result, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: result)
        }
      }
    }
  }
  
  class func findOneTime(byId objectId: String, completion handler: @escaping ObjectQueryResultHandler) {
    let dbRef = Database.database().reference()
    let collectionName = self.collectionName()
    
    let query = dbRef.child("\(collectionName)/\(objectId)")
    
    query.observeSingleEvent(of: .value) { snapshot in
      if !(snapshot.value is NSDictionary) {
        handler(nil, NotFoundError)
        return
      }
      
      let resultDict = snapshot.value as! NSDictionary
      let resultModel = self.mapObject(jsonObject: resultDict)
      handler(resultModel, nil)
    } withCancel: { error in
      handler(nil, error)
    }
  }
  
  // Read
  class func find(byId objectId: String, completion handler: @escaping ObjectQueryResultHandler) {
    let dbRef = Database.database().reference()
    let collectionName = self.collectionName()
    
    let query = dbRef.child("\(collectionName)/\(objectId)")
    
    query.observe(.value) { snapshot in
      if !(snapshot.value is NSDictionary) {
        handler(nil, NotFoundError)
        return
      }
      
      let resultDict = snapshot.value as! NSDictionary
      let resultModel = self.mapObject(jsonObject: resultDict)
      handler(resultModel, nil)
    } withCancel: { error in
      handler(nil, error)
    }
  }
  
  class func query(withClause queryClause: [QueryClausesEnum: AnyObject]? = nil,
                   completion handler: @escaping CollectionQueryResultHandler) {
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
        handler([], NotFoundError)
        return
      }
      
      var resultModels: [MBase] = []
      let results = snapshot.value as! [String: NSDictionary]
      
      for (_, resultDict) in results {
        let resultModel = self.mapObject(jsonObject: resultDict)
        
        if resultModel != nil {
          resultModels.append(resultModel!)
        }
      }
      
      handler(resultModels, nil)
    } withCancel: { error in
      handler([], error)
    }
  }
  
  func saveAsync() async throws -> String {
    return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
      do {
        var id = ""
        id = try self.save { error, _ in
          if let error = error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume(returning: id)
          }
        }
      } catch {
        continuation.resume(throwing: error)
      }
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
