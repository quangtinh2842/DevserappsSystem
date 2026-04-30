//
//  PhoneNumber.swift
//  DevserappsSystem
//
//  Created by Tịnh Ngô on 26/03/2025.
//

import Foundation
import ObjectMapper

class PhoneNumber: NSObject, Mappable {
  @objc var number: String?
  @objc var countryCode: CountryCode?
  
  init(phoneNumber: PhoneNumber?) {
    self.number = phoneNumber?.number
    self.countryCode = phoneNumber?.countryCode
  }
  
  override init() { super.init() }
  
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
    number          <- map["number"]
    countryCode     <- map["countryCode"]
  }
  
  func isDifferent(from phoneNumber: PhoneNumber?) -> Bool {
    if self.number != phoneNumber?.number {
      return true
    }
    
    if let countryCode = self.countryCode,
       countryCode.isDifferent(from: phoneNumber?.countryCode) {
      return true
    } else if let countryCode = phoneNumber?.countryCode,
              countryCode.isDifferent(from: self.countryCode) {
      return true
    }
    
    return false
  }
}
