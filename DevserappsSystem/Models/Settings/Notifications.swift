//
//  Appearance.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 25/03/2025.
//

import Foundation
import ObjectMapper

class Notifications: NSObject, Mappable {
  @objc var isAllOn: String?
  
  init(notifications: Notifications?) {
    self.isAllOn = notifications?.isAllOn
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
    isAllOn        <- map["isAllOn"]
  }
}
