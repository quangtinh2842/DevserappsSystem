//
//  Sensor.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper

class Control: NSObject, Mappable {
  @objc var symbolURL: URL?
  @objc var title: String?
  @objc var value: String?
  @objc var valueType: String?
  
  init(control: Control) {
    super.init()
    self.symbolURL = control.symbolURL
    self.title = control.title
    self.value = control.value
    self.valueType = control.valueType
  }
  
  required init?(map: Map) {
    super.init()
    
    let attributes = [String]()
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: Map) {
    symbolURL    <- (map["symbolURL"], URLTransform())
    title        <- map["title"]
    value        <- map["value"]
    valueType    <- map["valueType"]
  }
  
  override var description: String {
    return "<Control Title: \(self.title ?? "N/A") - Value: \(self.value ?? "N/A")>"
  }
  
  func validate() -> (ModelValidationError, String?) {
    return (.Valid, nil)
  }
  
  func isDifferent(from control: Control?) -> Bool {
    if self.symbolURL?.absoluteString != control?.symbolURL?.absoluteString {
      return true
    }
    
    if self.title != control?.title {
      return true
    }
    
    if self.value != control?.value {
      return true
    }
    
    if self.valueType != control?.valueType {
      return true
    }
    
    return false
  }
}
