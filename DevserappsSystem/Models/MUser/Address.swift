//
//  Geopoint.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 14/03/2025.
//

import Foundation
import ObjectMapper

class Address: NSObject, Mappable {
  @objc var provinceOrCity: String?
  @objc var district: String?
  @objc var wardOrCommune: String?
  @objc var specificAddress: String?
  @objc var geopoint: Geopoint?
  @objc var name: Name?
  @objc var phoneNumber: PhoneNumber?
  
  override init() { super.init() }
  
  init(address: Address?) {
    super.init()
    self.provinceOrCity = address?.provinceOrCity
    self.district = address?.district
    self.wardOrCommune = address?.wardOrCommune
    self.specificAddress = address?.specificAddress
    self.geopoint = address?.geopoint
    self.name = address?.name
    self.phoneNumber = address?.phoneNumber
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
    provinceOrCity  <- map["provinceOrCity"]
    district        <- map["district"]
    wardOrCommune   <- map["wardOrCommune"]
    specificAddress <- map["specificAddress"]
    geopoint        <- map["geopoint"]
    name            <- map["name"]
    phoneNumber     <- map["phoneNumber"]
  }
  
  override var description: String {
    return "<MAddress Region: \(self.regionAddress())>"
  }
  
  func isDifferent(from address: Address?) -> Bool {
    if self.provinceOrCity != address?.provinceOrCity {
      return true
    }
    
    if self.district != address?.district {
      return true
    }
    
    if self.wardOrCommune != address?.wardOrCommune {
      return true
    }
    
    if self.specificAddress != address?.specificAddress {
      return true
    }
    
    if let geopoint = self.geopoint,
        geopoint.isDifferent(from: address?.geopoint) {
      return true
    }
    
    if let geopoint = address?.geopoint,
       geopoint.isDifferent(from: self.geopoint) {
      return true
    }
    
    return false
  }
  
  func isEmpty() -> Bool {
    if (provinceOrCity == nil || provinceOrCity!.isEmpty) &&
        (district == nil || district!.isEmpty) &&
        (wardOrCommune == nil || wardOrCommune!.isEmpty) &&
        (specificAddress == nil || specificAddress!.isEmpty) &&
        (geopoint == nil) &&
        (name == nil) &&
        (phoneNumber == nil) {
      return true
    } else {
      return false
    }
  }
  
  func regionAddress() -> String {
    return [wardOrCommune, district, provinceOrCity].compactMap { $0 }.joined(separator: ", ")
  }
}
