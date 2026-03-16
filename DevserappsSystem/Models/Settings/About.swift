//
//  About.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 02/04/2025.
//

import Foundation
import ObjectMapper
import RealmSwift

class About: Object, Mappable {
  @objc var version: String?
  var resources = List<Resource>()
  
  override init() {
    super.init()
  }
  
  init(about: About?) {
    self.version = about?.version
    self.resources = about?.resources ?? List<Resource>()
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
    resources      <- (map["resources"], ListTransform<Resource>())
  }
}

class Resource: Object, Mappable {
  @objc dynamic var name: String?
  @objc dynamic var url: URL?
  
  init(name: String? = nil, url: URL?) {
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
    url        <- (map["url"], URLTransform())
  }
}
