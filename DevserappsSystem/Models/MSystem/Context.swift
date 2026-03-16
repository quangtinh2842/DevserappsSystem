//
//  Sensor.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper

class Context: NSObject, Mappable {
  @objc var symbolURL: URL?
  @objc var title: String?
  
  init(context: Context) {
    super.init()
    self.symbolURL = context.symbolURL
    self.title = context.title
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
    symbolURL    <- (map["symbolURL"], URLTransform())
  }
  
  override var description: String {
    return "<Context Title: \(self.title ?? "N/A") - Symbol URL: \(self.symbolURL?.absoluteString ?? "N/A")>"
  }
  
  func validate() -> (ModelValidationError, String?) {
    return (.Valid, nil)
  }
  
  func isDifferent(from context: Context?) -> Bool {
    if self.title != context?.title {
      return true
    }
    
    if self.symbolURL?.absoluteString != context?.symbolURL?.absoluteString {
      return true
    }
    
    return false
  }
}
