//
//  Sensor.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper

class Context: NSObject, Mappable {
  @objc var symbolURL: String?
  @objc var title: String?
  
  var getSymbolURL: URL? {
    if symbolURL == nil {
      return nil
    } else {
      return URL(string: symbolURL!)
    }
  }
  
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
    symbolURL    <- map["symbolURL"]
  }
  
  override var description: String {
    return "<Context Title: \(self.title ?? "N/A") - Symbol URL: \(self.symbolURL ?? "N/A")>"
  }
  
  func validate() -> (ModelValidationError, String?) {
    return (.Valid, nil)
  }
  
  func isDifferent(from context: Context?) -> Bool {
    if self.title != context?.title {
      return true
    }
    
    if self.symbolURL != context?.symbolURL {
      return true
    }
    
    return false
  }
}
