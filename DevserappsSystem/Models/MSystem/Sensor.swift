//
//  Sensor.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper

class Sensor: NSObject, Mappable {
  @objc var title: String?
  @objc var value: String?
  @objc var symbolURL: String?
  @objc var valueType: String?
  @objc var unit: String?
  @objc var time: Date?
  
  var getSymbolURL: URL? {
    if symbolURL == nil {
      return nil
    } else {
      return URL(string: symbolURL!)
    }
  }
  
  init(sensor: Sensor) {
    super.init()
    self.title = sensor.title
    self.value = sensor.value
    self.symbolURL = sensor.symbolURL
    self.valueType = sensor.valueType
    self.unit = sensor.unit
    self.time = sensor.time
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
    title        <- map["title"]
    value        <- map["value"]
    symbolURL    <- map["symbolURL"]
    valueType    <- map["valueType"]
    unit         <- map["unit"]
    time         <- (map["time"], DateTransform())
  }
  
  override var description: String {
    return "<Sensor Title: \(self.title ?? "N/A") - Value: \(self.value ?? "N/A")>"
  }
  
  func validate() -> (ModelValidationError, String?) {
    return (.Valid, nil)
  }
  
  func isDifferent(from sensor: Sensor?) -> Bool {
    if self.title != sensor?.title {
      return true
    }
    
    if self.value != sensor?.value {
      return true
    }
    
    if self.symbolURL != sensor?.symbolURL {
      return true
    }
    
    if self.valueType != sensor?.valueType {
      return true
    }
    
    if self.unit != sensor?.unit {
      return true
    }
    
    if self.time != sensor?.time {
      return true
    }
    
    return false
  }
}
