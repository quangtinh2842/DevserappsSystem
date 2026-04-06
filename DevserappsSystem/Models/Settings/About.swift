//
//  About.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/04/2025.
//

import Foundation
import ObjectMapper

class About: Mappable {
  var version: String?
  var resources: [Resource]?

  init(about: About?) {
    self.version = about?.version
    self.resources = about?.resources
  }
  
  required init?(map: ObjectMapper.Map) {
    let attributes: [String] = []
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: ObjectMapper.Map) {
    version        <- map["version"]
    resources      <- map["resources"]
  }
}

class Resource: Mappable {
  var name: String?
  var url: String?
  
  init(name: String? = nil, url: String?) {
    self.name = name
    self.url = url
  }
  
  init(resource: Resource?) {
    self.name = resource?.name
    self.url = resource?.url
  }
  
  required init?(map: ObjectMapper.Map) {
    let attributes: [String] = []
    let validations = attributes.map {
      map[$0].currentValue != nil
    }.reduce(true) { $0 && $1 }
    
    if !validations {
      return nil
    }
  }
  
  func mapping(map: ObjectMapper.Map) {
    name       <- map["name"]
    url        <- map["url"]
  }
}
