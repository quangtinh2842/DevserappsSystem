//
//  Geopoint.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper

class Name: NSObject, Mappable {
  @objc var last: String?
  @objc var middle: String?
  @objc var first: String?
  
  init(nameParam: Name?) {
    self.last = nameParam?.last
    self.middle = nameParam?.middle
    self.first = nameParam?.first
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
    last        <- map["last"]
    middle      <- map["middle"]
    first       <- map["first"]
  }
  
  func isDifferent(from name: Name?) -> Bool {
    if self.last != name?.last {
      return true
    }
    
    if self.middle != name?.middle {
      return true
    }
    
    if self.first != name?.first {
      return true
    }
    
    return false
  }
  
  func fullName() -> String {
    return [last, middle, first].compactMap { $0 }.joined(separator: " ")
  }
}
